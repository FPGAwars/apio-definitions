# Developer tools

> **Note:** This file is maintained by Claude Code, based on requests from the developers. It's not meant to be edited by hand. To change it, ask Claude.

This repo has a few Python tools for testing and maintaining the examples: Invoke tasks in `tasks.py`, and scripts in `scripts/`. Run the scripts from the repo root, since they use paths relative to the current dir. The Invoke tasks can run from any dir in the repo.

## Invoke tasks (`tasks.py`)

`tasks.py` is modeled on the one in the Apio repo. It needs Invoke (`pip install invoke`). Run `invoke --list` to see the tasks. The tasks don't support Invoke's `--dry` option and exit with an error if it's given, and the scripts have no dry-run option.

| Task | Alias | What it does |
|---|---|---|
| `invoke lint` | `l` | Formats the Python code in `scripts/` and `tasks.py` with black, then checks it with pylint and mypy. |
| `invoke test` | `t` | Runs `test_examples.py` on the selected examples, using this repo's definitions (see below). Option `--examples-root <dir>` tests the examples in another dir. |
| `invoke format` | `f` | Runs `apio format` in each selected example, which formats the Verilog with Verible. |
| `invoke copy-common` | `cc` | Runs `copy_common_examples_files.py` on the selected examples. |
| `invoke clean` | `c` | Runs `apio clean` in each selected example and deletes the common files from them (`copy_common_examples_files.py --clean`). It also deletes the `.mypy_cache` and `__pycache__` dirs of the whole repo, since they belong to the Python tooling, not to the examples. |

The tasks that work on examples (`test`, `format`, `copy-common` and `clean`) select the examples from the dir they run in. Each one prints what it selected. `lint` doesn't work on examples, so it ignores the current dir.

| Run from | Selected examples |
|---|---|
| A board dir (`examples/<board>`) | That board's examples |
| An example dir (`examples/<board>/<example>`) or a dir inside it | That example |
| Anywhere else | All the examples |

So after editing `common-examples-files/`, run `invoke copy-common` from the repo root to update all the examples. The CI workflows run the tasks from the repo root, so they always work on all the examples.

`invoke test` runs `test_examples.py` with the env var `APIO_DEFINITIONS` set to this repo's `definitions/` dir. Every `apio` command the script runs then reads `boards.jsonc`, `fpgas.jsonc` and `programmers.jsonc` from this repo instead of from the installed definitions package. Other content of the installed package, such as its examples, is still used from the package. This needs an Apio version that supports `APIO_DEFINITIONS`. If `APIO_DEFINITIONS` is already set to another dir, `invoke test` fails.

## Scripts (`scripts/`)

**`test_examples.py`** tests the examples. With no options it tests all of them. Options:
- `--example <board>` tests one board's examples, and `--example <board>/<example>` tests one example.
- `--examples-root <dir>` tests the examples in another dir.

For each env of each example, it runs `apio build`, `lint`, `lint --nosynth`, `graph`, `report`, `test`, `sim --no-gtkwave`, `format`, and `apio api` commands. It stops at the first failure.

To check one example by hand, `cd examples/<board>/<example>` and run the same `apio` commands, e.g. `apio build -e <env>`, `apio test`, `apio format`.

**`copy_common_examples_files.py`** copies the shared files into every example (see "Common example files" below). Option `--clean` removes the copied files. Option `--example <board>` or `--example <board>/<example>` processes only that board's examples or only that example.

## Deleting files in Python code

Before `tasks.py` or a script in `scripts/` deletes a file or dir, it must check that the path is inside this repo and isn't the repo root. Use the `delete_path()` helper in `tasks.py` or in `copy_common_examples_files.py`, which does this check. Don't call `shutil.rmtree()` or `unlink()` directly.

## Common example files

Some files are the same in every example: a `.gitignore` and a `.vscode/` dir. They are kept once in `common-examples-files/` and are not committed into each example. `copy_common_examples_files.py` copies them into every example at CI and package-build time. To change them, edit `common-examples-files/`, not the copies in the examples.

## CI (`.github/workflows/`)

| Workflow | Runs | What it does |
|---|---|---|
| `test.yaml` | On push, on PRs, and daily, on Linux, macOS and Windows | Installs the dev version of Apio, overwrites the installed package's definitions and examples with this repo's, then runs `test_examples.py` against the installed copy. |
| `build-pre-release.yaml` | Daily, and manually | Packages `definitions/*`, `examples/`, `LICENSE` and `BUILD-INFO.json` into `apio-definitions-<tag>.tgz` and publishes it as a GitHub pre-release, using shared actions from `fpgawars/apio-workflows`. |

## Line endings

`.gitattributes` forces LF line endings for `*.v`, `*.vh`, `*.sv` and `*.svh` files, because Verible's formatter fails on CRLF files that use `// verilog_format: off`.
