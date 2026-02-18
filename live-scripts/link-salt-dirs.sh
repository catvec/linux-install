#!/usr/bin/env bash

# Helpers
function die() {
    echo "Error: $@" >&2
    exit 1
}


function bold() {
    echo "$(tput bold)$@$(tput sgr0)"
}

function check() {
    if [ "$?" -ne 0 ]; then
        die "$@"
    fi
}

# Configuration
repo_dir=/etc/linux-install
salt_content_dir=/srv

salt_state_links=(
    "$repo_dir/secrets/salt/base:$salt_content_dir/salt/base-secret"
)

salt_pillar_links=(
    "$repo_dir/secrets/pillar/base:$salt_content_dir/pillar/base-secret"
    "$repo_dir/secrets/pillar/gentoo:$salt_content_dir/pillar/gentoo-secret"
    "$repo_dir/secrets/pillar/arch:$salt_content_dir/pillar/arch-secret"
)

# Explore the salt directory to find environments and add those links to salt_state_links
discover_salt_state_links() {
    find_out=$(find "$repo_dir/salt" -maxdepth 1 -mindepth 1 -type d)
    check "Failed to search salt directory for environments"

    while IFS= read -r dir; do
        env_name=$(basename "$dir")
        check "Failed to convert directory into environment name"

        salt_state_links+=("$repo_dir/salt/$env_name:$salt_content_dir/salt/$env_name")
    done <<< "$find_out"
}

# Explore the pillar directory to find environments and add those links to salt_pillar_links
discover_salt_pillar_links() {
    find_out=$(find "$repo_dir/pillar" -maxdepth 1 -mindepth 1 -type d)
    check "Failed to search pillar directory for environments"

    while IFS= read -r dir; do
        env_name=$(basename "$dir")
        check "Failed to convert directory into environment name"

        salt_pillar_links+=("$repo_dir/pillar/$env_name:$salt_content_dir/pillar/$env_name")
    done <<< "$find_out"
}

discover_salt_state_links
discover_salt_pillar_links

# Parse options
while getopts "hspa" opt; do
    case "$opt" in
	h) cat <<EOF
link-salt-dirs.sh - Link Salt directories

USAGE

    link-salt-dirs.sh [-h,-s,-p,-a]

OPTIONS

    -h    Show this help text
    -s    Print list of link information on Salt state directories.
    -p    Print list of link information on Salt pillar directories.
    -a    Print all list with all link information (Equivalent to -s and -p combined).

BEHAVIOR

    Creates symbolic links from this repository's Salt state and pillar directories to the 
    system's global directories where Salt expects them. Mainly in /srv/{salt,pillar}.

    This script also provides an interface to learn information about the structure of this
    repository. The -s,-p, and -a options do not create any links. Instead they return a space
    seperated list of link information. Each item in this list is in the format:

        <directory in repository>:<link target>

EOF
	   exit 0
	   ;;
	s)
	    echo "${salt_state_links[@]}"
	    exit 0
	    ;;
	p)
	    echo "${salt_pillar_links[@]}"
	    exit 0
	    ;;
	a)
	    echo "${salt_state_links[@]} ${salt_pillar_links[@]}"
	    exit 0
	    ;;
	'?') die "Unknown option" ;;
    esac
done

# Link
test -d "$repo_dir"
check "Repository directory \"$repo_dir\" doesn't exist"

mkdir -p "$salt_content_dir"
check "Failed to make parent directory for links \"$salt_content_dir\""

for subdir in salt pillar; do
    mkdir -p "$salt_content_dir/$subdir"
    check "Failed to make parent directory for links \"$salt_content_dir/$subdir\""
done

bold "Linking"
for link_info in "${salt_state_links[@]}" "${salt_pillar_links[@]}"; do
	original_dir=$(echo "$link_info" | awk -F ':' '{ print $1 }')
	link_dir=$(echo "$link_info" | awk -F ':' '{ print $2 }')
	
	# Check if link exists
	if [ -L "$link_dir" ]; then
		echo "Link \"$link_dir\" already exists, skipping"
		continue
	fi

	# Link
	ln -s "$original_dir" "$link_dir"
	check "Failed to link \"$link_dir\" -> \"$original_dir\""
	echo "Linked \"$link_dir\" -> \"$original_dir\""
done

bold "Linked"
