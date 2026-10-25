"""Tasks definitions for the 'invoke' command."""

# To install 'invoke' run: pip install invoke
#
# A few useful Invoke tasks
#   invoke --list         # Show available tasks
#   invoke -l             # Show available tasks
#   invoke lint           # Format and lint the python code.
#   invoke test           # Test the examples.
#   invoke format         # Format the examples' Verilog files.
#   invoke copy-common    # Copy the common files into the examples.
#   invoke clean          # Clean the examples and other temporary files.
#
# The tasks that work on examples (test, format, copy-common, clean) pick
# them from the current dir: in a board dir that board's examples, in an
# example dir (or below it) that example, and anywhere else all of them.

#  NOTE: The shortcut 'inv' can be used instead of 'invoke'.

import sys
import os
from os import sep
from pathlib import Path
import shutil
import subprocess
from subprocess import CompletedProcess
from importlib.metadata import version, PackageNotFoundError
from invoke.tasks import task
from invoke.context import Context

# ========================== Helper definitions ===============================


# -- NOTE: The first sentence of a task docstring is also its help string
# -- which is printed when running 'invoke --list'.

# -- The python interpreter that we currently use.
PYTHON = sys.executable


def package_version(package_name: str) -> str | None:
    """Get the version of installed package or None if not installed."""
    try:
        return version(package_name)
    except PackageNotFoundError:
        return None


def install_package(package_name: str, required_version: str) -> None:
    """If the package/version is not installed then install it. Otherwise
    do nothing."""
    # -- Update if needed.
    if package_version(package_name) != required_version:
        print(f"\n*** Auto installing {package_name}@{required_version} ***")
        subprocess.check_call(
            [
                sys.executable,
                "-m",
                "pip",
                "install",
                "--force-reinstall",
                f"{package_name}=={required_version}",
            ]
        )

    # -- Verify.
    assert (
        package_version(package_name) == required_version
    ), f"Expected to find {package_name}=={required_version}"


DEPENDENCIES = [
    ("rich", "14.0.0"),
    ("black", "25.1.0"),
    ("pylint", "3.3.7"),
    ("mypy", "2.3.1"),
]


def install_dependencies():
    """Install any dependency that is missing or has a different version."""
    for package_name, required_version in DEPENDENCIES:
        install_package(package_name, required_version)


# -- Make sure required python dependencies are installed.
install_dependencies()


# -- Now that Rich is installed, we can import and use it.
# pylint: disable=wrong-import-position
from rich.console import Console

# -- For outputting via Rich. The regular rich.print() doesn't not allow to
# -- disable markup.
console = Console()


def cout(*args, markup=False, highlight=False, **kwargs):
    """A shortcut for Rich lib console.print()."""
    console.print(*args, markup=markup, highlight=highlight, **kwargs)


def announce_task(ctx: Context, task_name: str) -> None:
    """Prints a message saying that the task is starting. Every task calls
    it first. The tasks don't support Invoke's --dry option, so it aborts
    if it's given."""
    if ctx.config.run.dry:
        cout("The --dry option is not supported.", style="red bold")
        sys.exit(1)
    cout(
        f"Executing Apio definitions dev task: {task_name}",
        style="magenta bold",
    )


def get_repo_root() -> Path:
    """Return the root of the local apio definitions github repository."""
    # -- Return the directory that contains this file.
    return Path(__file__).resolve().parent


def delete_path(path: Path) -> None:
    """Delete a file or a directory tree. The path must be inside the repo.
    Use this for every delete in this file."""
    # -- Safety check. Resolve the parent dirs but not the item itself, so
    # -- a symlink is checked (and deleted) as a link.
    repo_root = get_repo_root()
    real_path = path.parent.resolve() / path.name
    assert (
        real_path.is_relative_to(repo_root) and real_path != repo_root
    ), f"Refusing to delete {real_path}, it's not inside {repo_root}"

    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink()


def examples_selection(examples_dir: Path) -> str | None:
    """Select the examples to work on from the current dir. Returns
    '<board>' in a board dir, '<board>/<example>' in an example dir or
    below it, and None (all examples) anywhere else."""
    cwd = Path.cwd().resolve()
    examples_dir = examples_dir.resolve()
    if not cwd.is_relative_to(examples_dir):
        return None
    parts = cwd.relative_to(examples_dir).parts
    if not parts:
        return None
    return "/".join(parts[:2])


def selection_name(selection: str | None) -> str:
    """A name of the selection for messages."""
    return selection or "all examples"


def get_example_dirs(selection: str | None) -> list[Path]:
    """Return the dirs of the repo's examples, sorted. Examples are at
    examples/<board>/<example>. 'selection' is a value returned by
    examples_selection(). If it's None, return all the examples."""
    examples_dir = get_repo_root() / "examples"
    assert examples_dir.is_dir(), examples_dir
    example_dirs = sorted(
        example_dir
        for board_dir in examples_dir.iterdir()
        if board_dir.is_dir()
        for example_dir in board_dir.iterdir()
        if example_dir.is_dir()
    )
    if selection:
        parts = tuple(selection.split("/"))
        example_dirs = [
            example_dir
            for example_dir in example_dirs
            if example_dir.relative_to(examples_dir).parts[: len(parts)]
            == parts
        ]
    assert example_dirs, f"No examples found for {selection}"
    return example_dirs


def run(cmd: list[str], cwd: Path | None = None) -> None:
    """Run a command, in dir 'cwd' if specified. Abort if it returns an
    error code."""
    # -- Show the dir relative to the repo root, e.g. [examples/x/y].
    where = f"[{cwd.relative_to(get_repo_root()).as_posix()}] " if cwd else ""
    cout(f"{where}{' '.join(cmd)}", style="cyan")
    result: CompletedProcess = subprocess.run(cmd, cwd=cwd, check=False)
    if result.returncode != 0:
        cout("Command failed.", style="red bold")
        sys.exit(1)


# ===================== Tasks definitions start here ==========================


@task(name="lint", aliases=["l"])
def lint_task(ctx: Context):
    """Format and lint the python code."""
    announce_task(ctx, "lint")
    # -- Paths are relative to the repo root.
    os.chdir(get_repo_root())
    lint_items = ["scripts", "tasks.py"]
    run([PYTHON, "-m", "black", "--line-length", "79", *lint_items])
    run([PYTHON, "-m", "pylint", *lint_items])
    run([PYTHON, "-m", "mypy", *lint_items])
    cout("Lint passed.", style="green bold")


@task(
    name="test",
    aliases=["t"],
    help={
        "examples_root": "Test the examples in this dir instead of the "
        "repo's examples dir.",
    },
)
def test_task(ctx: Context, examples_root: str | None = None):
    """Test the examples. In a board dir it tests that board's examples, in
    an example dir it tests that example, and anywhere else all of them."""
    announce_task(ctx, "test")
    # -- Make apio read boards.jsonc, fpgas.jsonc and programmers.jsonc
    # -- from this repo instead of from the installed definitions package.
    # -- The apio commands that the test script runs inherit this env var.
    # -- If the var is already defined, it must match what we would set.
    env_var = "APIO_DEFINITIONS"
    current = os.environ.get(env_var)
    definitions_dir = get_repo_root() / "definitions"
    assert current is None or Path(current).resolve() == definitions_dir, (
        f"{env_var} is already defined as [{current}], "
        f"expected [{definitions_dir}]."
    )
    os.environ[env_var] = str(definitions_dir)
    cout(f"{env_var}={definitions_dir}", style="cyan")
    cmd = [PYTHON, f"scripts{sep}test_examples.py"]
    examples_dir = get_repo_root() / "examples"
    if examples_root:
        # -- Make it absolute before we change the current dir.
        examples_dir = Path(examples_root).resolve()
        cmd += ["--examples-root", str(examples_dir)]
    # -- Pick the examples from the current dir, before we change it.
    selection = examples_selection(examples_dir)
    if selection:
        cmd += ["--example", selection]
    # -- The scripts use paths relative to the repo root.
    os.chdir(get_repo_root())
    run(cmd)
    cout(f"Passed: {selection_name(selection)}.", style="green bold")


@task(name="format", aliases=["f"])
def format_task(ctx: Context):
    """Format the examples' Verilog code. Picks the examples from the
    current dir, like 'invoke test'."""
    announce_task(ctx, "format")
    selection = examples_selection(get_repo_root() / "examples")
    cout(f"Formatting: {selection_name(selection)}", style="cyan")
    for example_dir in get_example_dirs(selection):
        run(["apio", "format"], cwd=example_dir)
    cout(f"Formatted: {selection_name(selection)}.", style="green bold")


@task(name="copy-common", aliases=["cc"])
def copy_common_task(ctx: Context):
    """Copy the common files into the examples. Picks the examples from
    the current dir, like 'invoke test'."""
    announce_task(ctx, "copy-common")
    # -- Pick the examples from the current dir, before we change it.
    selection = examples_selection(get_repo_root() / "examples")
    cout(f"Copying common files: {selection_name(selection)}", style="cyan")
    # -- The scripts use paths relative to the repo root.
    os.chdir(get_repo_root())
    cmd = [PYTHON, f"scripts{sep}copy_common_examples_files.py"]
    if selection:
        cmd += ["--example", selection]
    run(cmd)


@task(name="clean", aliases=["c", "cl"])
def clean_task(ctx: Context):
    """Clean artifacts and temporary files. Picks the examples from the
    current dir, like 'invoke test'."""
    announce_task(ctx, "clean")
    repo_root = get_repo_root()
    assert isinstance(repo_root, Path)

    # -- Pick the examples from the current dir, before we change it.
    selection = examples_selection(repo_root / "examples")
    cout(f"Cleaning: {selection_name(selection)}", style="cyan")

    # -- The scripts use paths relative to the repo root.
    os.chdir(repo_root)

    # -- Run 'apio clean' in each selected example.
    for example_dir in get_example_dirs(selection):
        run(["apio", "clean"], cwd=example_dir)

    # -- Delete the common files that 'invoke copy-common' copied into
    # -- the selected examples.
    cmd = [PYTHON, f"scripts{sep}copy_common_examples_files.py", "--clean"]
    if selection:
        cmd += ["--example", selection]
    run(cmd)

    # -- The Python caches below belong to the tooling, not to the
    # -- examples, so they are always deleted from the whole repo.

    # -- Collect other items to delete.
    items: list[Path] = []
    # -- Collect top level items first so they will be deleted first.
    items.extend(repo_root.glob(".mypy_cache"))
    # -- Collect nested items
    items.extend(repo_root.rglob("__pycache__"))

    if not items:
        print("No other items to delete.")
        return

    print("Deleting:")

    for item in items:
        # -- E.g. if we hit a __pycache__ under .mypy_cache but already
        # -- deleted .mypy_cache.
        if not item.exists():
            continue

        description = "{repo}/" + str(item.relative_to(repo_root))
        print(f"[{'d' if item.is_dir() else 'f'}] {description}")
        delete_path(item)
