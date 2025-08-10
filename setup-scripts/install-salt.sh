#!/usr/bin/env bash
set -xeuo pipefail
readonly PROG_DIR=$(dirname $(realpath "$0"))

readonly SALT_VERSION="3007.6"
readonly ONEDIR_DOWNLOAD_URL="https://packages.broadcom.com/artifactory/saltproject-generic/onedir/${SALT_VERSION}/salt-${SALT_VERSION}-onedir-linux-x86_64.tar.xz"
readonly ONEDIR_DOWNLOAD_SHA="5d65442973b3db93b882dabb20d8c379950c68bd67c0aec5db8072d63eeaf5c7"
readonly ONEDIR_PARENT_DIR="/opt"
readonly ONEDIR_DIR="${ONEDIR_PARENT_DIR}/salt"
readonly ONEDIR_DOWNLOAD_FILE="${PROG_DIR}/../salt-onedir.tar.xz"

readonly LINK_DEST_DIR="/usr/local/bin"

# Options
OPT_FORCE=""
while getopts "hf" opt; do
    case "$opt" in
        h)
            cat <<EOF
install-salt.sh - Install the Salt onedir installation

USAGE

    install-salt.sh [-h] [-f]

OPTIONS

    -h    Show this help text and exit
    -f    Replace the existing installation if it exists

EOF
        exit 0
        ;;
        f) OPT_FORCE="y" ;;
        '?')
            echo "Error: Unknown options" >&2
            exit 1
            ;;
    esac
done

# Clean up existing install if re-installing
if [[ -d "$ONEDIR_DIR" ]]; then
    echo "Re-installing"

    # Remove links
    for src_file in "${ONEDIR_DIR}"/salt*; do
        file_basename="$(basename $src_file)"
        dest_file="${LINK_DEST_DIR}/${file_basename}"

        if [[ -f "$dest_file" ]]; then
            rm "$dest_file"
            echo "Cleaned up link '$dest_file' (Linked to '$src_file')"
        fi
    done

    # Clean up onedir dir
    rm -rf "$ONEDIR_DIR"
fi

# Install files
if ! [[ -d "$ONEDIR_DIR" ]]; then
    # Download
    if ! [[ -f "$ONEDIR_DOWNLOAD_FILE" ]]; then
        curl -o "${ONEDIR_DOWNLOAD_FILE}" -L "${ONEDIR_DOWNLOAD_URL}"
    else
        echo "Skipping downloading because '${ONEDIR_DOWNLOAD_FILE}' already exists"
    fi
    cat <<EOF | sha256sum --check --status
${ONEDIR_DOWNLOAD_SHA}  ${ONEDIR_DOWNLOAD_FILE}
EOF

    # Decompress
    decompress() {
        cd "$ONEDIR_PARENT_DIR"
        tar -xf "$ONEDIR_DOWNLOAD_FILE"

        if ! [[ -d "$ONEDIR_DIR" ]]; then
            echo "Error: Salt onedir compressed file was supposed to have a directory name 'salt' in it, but when decompressed we could not find '${ONEDIR_DIR}'" >&2
            exit 1
        fi
    }
    decompress
fi

# Cleanup
if [[ -f "$ONEDIR_DOWNLOAD_FILE" ]]; then
    rm "$ONEDIR_DOWNLOAD_FILE"
fi

# Make links
set +x
for src_file in "${ONEDIR_DIR}"/salt*; do
    file_basename="$(basename $src_file)"
    dest_file="${LINK_DEST_DIR}/${file_basename}"

    if ! [[ -f "$dest_file" ]]; then
        ln -s "$src_file" "$dest_file"
        echo "Linked '$src_file' to '$dest_file'"
    else
        echo "Not making link to '$dest_file' because already exists"
    fi
done
