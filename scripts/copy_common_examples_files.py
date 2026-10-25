#!/usr/bin/env python3
"""
copy-common-files.py

NOTE: Don't run this script directly. Run it via the invoke task
'invoke copy-common' (see tasks.py at the repo root).

Run from repository root.

By default it copies the common files into the examples.
Use --clean to delete them from the examples instead.

Use --example <board> or --example <board>/<example> to process only
that board's examples or only that example.

Usage:
    ./process-common-files.py                 # copy (default)
    ./process-common-files.py --clean         # delete shared files
    ./process-common-files.py --example alhambra-ii/blinky  # one example
"""

import shutil
import argparse
from pathlib import Path
import sys

parser = argparse.ArgumentParser(
    description="Copy or clean common example files"
)
parser.add_argument(
    "--clean",
    action="store_true",
    help="Delete common files from examples instead of copying",
)
parser.add_argument(
    "--example",
    type=str,
    default=None,
    help="Process only this board (e.g. alhambra-ii) or this example "
    "(e.g. alhambra-ii/blinky)",
)
args = parser.parse_args()


COMMON_DIR = Path("common-examples-files")
EXAMPLES_DIR = Path("examples")

# -- The root of this repo. This script is at <repo>/scripts.
REPO_DIR = Path(__file__).resolve().parent.parent


def get_targets() -> list[Path]:
    """Get the sorted list of example dirs to process. If --example is
    given, only that board's examples or only that example."""
    targets = sorted(
        p
        for board in EXAMPLES_DIR.iterdir()
        if board.is_dir()
        for p in board.iterdir()
        if p.is_dir()
    )
    if args.example:
        parts = tuple(args.example.strip("/").split("/"))
        assert len(parts) in (1, 2), f"Invalid --example '{args.example}'"
        targets = [
            p
            for p in targets
            if p.relative_to(EXAMPLES_DIR).parts[: len(parts)] == parts
        ]
        if not targets:
            print(f"Error: No examples found for --example {args.example}")
            sys.exit(1)
    return targets


def delete_path(path: Path) -> None:
    """Delete a file or a directory tree. The path must be inside the repo."""
    # -- Safety check. Resolve the parent dirs but not the item itself, so
    # -- a symlink is checked (and deleted) as a link.
    real_path = path.parent.resolve() / path.name
    assert (
        real_path.is_relative_to(REPO_DIR) and real_path != REPO_DIR
    ), f"Refusing to delete {real_path}, it's not inside {REPO_DIR}"

    if path.is_dir() and not path.is_symlink():
        shutil.rmtree(path)
    else:
        path.unlink()


def process_one_example(example_dir: Path, clean: bool) -> int:
    """Process a single example directory: copy or delete common files."""
    count = 0
    for item in COMMON_DIR.iterdir():
        dest = example_dir / item.name

        if clean:
            if dest.exists():
                delete_path(dest)
                print(f"Deleted: {dest}")
                count += 1
        else:
            if dest.exists():
                delete_path(dest)
            (shutil.copytree if item.is_dir() else shutil.copy2)(item, dest)
            print(f"Copied: {dest}")
            count += 1
    return count


def main():
    """Main"""

    if not COMMON_DIR.exists():
        print(f"Error: Directory not found: {COMMON_DIR}")
        sys.exit(1)

    targets = get_targets()
    if not targets:
        print("No example directories found under examples/")
        return

    action = "DELETE" if args.clean else "COPY"
    print(f"{action} common files → {len(targets)} example directories\n")

    total_count = 0
    for example_dir in targets:
        total_count += process_one_example(example_dir, args.clean)

    verb = "deleted" if args.clean else "copied"
    print(
        f"\nDone! {total_count} items {verb} across {len(targets)} directories."
    )


if __name__ == "__main__":
    main()
