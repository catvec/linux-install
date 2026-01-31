#!/usr/bin/env bash
set -euo pipefail

readonly PROG_DIR=$(dirname $(realpath "$0"))
readonly EXPORT_DIR="$PROG_DIR/../secrets/salt/base/gpg-secret/${USER}"

# Options
while getopts "h" opt; do
    case "$opt" in
        h)
            cat <<EOF
gpg-export.sh - Export a user's GPG keys into the correct linux install directory

USAGE

  gpg-export [-h] KEY_ID

OPTIONS

  -h    Show help text

ARGUMENTS

  KEY_ID    ID of GPG key

BEHAVIOR

  Exports priv.asc, pub.asc, and trust.asc to $(realpath ${EXPORT_PATH}) for the current user.

EOF
            exit 0
            ;;
        '?')
            echo "Error: Unknown option" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

# Arguments
if (( $# != 1 )); then
    echo "Error: Must provide KEY_ID argument" >&2
    exit 1
fi
KEY_ID="$1"

if ! gpg --list-keys | grep "$KEY_ID" > /dev/null; then
    echo "Error: Could not find key '$KEY_ID'" >&2
    exit 1
fi

# Export
set -x
mkdir -p "$EXPORT_DIR"
gpg --export --armor "$KEY_ID" > "${EXPORT_DIR}/pub.asc"
gpg --export-secret-keys --armor "$KEY_ID" > "${EXPORT_DIR}/priv.asc"
gpg --export-ownertrust > "${EXPORT_DIR}/trust.asc"
