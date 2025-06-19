#!/usr/bin/env bash
set -xeuo pipefail
readonly PROG_DIR=$(dirname $(realpath "$0"))
readonly ONEDIR_DOWNLOAD_URL="https://packages.broadcom.com/artifactory/saltproject-generic/onedir/3007.1/salt-3007.1-onedir-linux-x86_64.tar.xz"
readonly ONEDIR_DOWNLOAD_SHA="a8e48e5b8ef41574ea7bfd3f532e1b81f6805edb5ff3a7c77b364641a00a56c9"
readonly ONEDIR_PARENT_DIR="/opt"
readonly ONEDIR_DIR="${ONEDIR_PARENT_DIR}/salt"
readonly ONEDIR_DOWNLOAD_FILE="${PROG_DIR}/../salt-onedir.tar.xz"

readonly LINK_DEST_DIR="/usr/local/bin"

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
