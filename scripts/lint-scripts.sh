#!/usr/bin/env bash

# A script to lint the python scripts in the 'scripts' directory.

echo "Installing pylint if missing"
pip install pylint -q

echo "Linting ./scripts"
pylint ./scripts
