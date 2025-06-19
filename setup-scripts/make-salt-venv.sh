#!/usr/bin/env bash
set -euo pipefail
readonly PROG_DIR=$(dirname $(realpath "$0"))
readonly VENV_DIR="$PROG_DIR/../.venv"
readonly SALT_VERSION=3007.1

if ! [[ -d "$VENV_DIR" ]]; then
    python -m venv "$VENV_DIR"
else
    echo "Salt venv '${VENV_DIR}' already existed"
fi

source "$VENV_DIR/bin/activate"
pip_pkgs=("salt==${SALT_VERSION}")
for pkg in "${pip_pkgs[@]}"; do
    echo "Installing PyPi package '$pkg'"
    pip3 install "$pkg"
done
