#!/usr/bin/env bash
set -e

PROG_DIR=$(realpath $(dirname "$0"))

die () { # (msg)
    msg="$1"
    echo "Error: $1" >&2
    exit 1
}

# Options
ENV=""
while getopts "he:n:d:" opt; do
    case "$opt" in
        h)
            cat <<EOF
scaffold_multipkg_state.sh - Create files and directories to install a package via the multipkg module

USAGE

    scaffold_multipkg_state.sh [-h] [-e ENV] NAME

OPTIONS

    -h        Show this help text and exit
    -n NAME   Name of state (alphanumeric or dashes, cannot start or end with dash)
    -d DESC   Description of what package will be installed (put as comment at top of state dir), madlibs in the sentence "Installs DESC"
    -e ENV    Name of pillar ENV in which to create additional pillar file

BEHAVIOR

    Creates a state in the base environment which installs packages specified by the pillar. If the ENV option is provided also creates a pillar file for that env.

EOF
            exit 0
            ;;
        n) NAME="$OPTARG" ;;
        d) DESC="$OPTARG" ;;
        e) ENV="$OPTARG" ;;
        '?') die "Unknown option" ;;
    esac
done

shift $((OPTIND-1))

if [[ -z "$NAME" ]]; then
    die "NAME argument must be provided"
fi

if [[ $NAME =~ ^[a-z0-9][a-z-0-9]*[a-z0-9]$ ]]; then
    die "NAME argument can only contain lowercase numbers, letters, or dashes (May not start or end with a dash)"
fi

if [[ -z "$DESC" ]]; then
    die "DESC argument must be provided"
fi

# Make directories
salt_base_dir="$PROG_DIR/../salt/base/$NAME"
pillar_base_dir="$PROG_DIR/../pillar/base/$NAME"
pillar_env_dir="$PROG_DIR/../pillar/$ENV/$NAME"

mkdir -p "$salt_base_dir"
mkdir -p "$pillar_base_dir"

if [[ -n "$ENV" ]]; then
    mkdir -p "$pillar_env_dir"
fi

# Fill in files
salt_base_file="$salt_base_dir/init.sls"
pillar_files=("$pillar_base_dir/init.sls")
if [[ -n "$ENV" ]]; then
    pillar_files+=("$pillar_env_dir/init.sls")
fi

jinja_name=$(echo "$NAME" | sed 's/-/_/g')

if ! [[ -f "$salt_base_file" ]]; then
    echo "${salt_base_file}:"
    cat <<EOF | tee "$salt_base_file"
# Installs $DESC
${jinja_name}_pkgs:
  multipkg.installed:
    - pkgs: {{ pillar.${jinja_name}.multipkgs }}
EOF
else
    echo "Not writing scaffold salt state to '$salt_base_file' because it already exists"
fi

for pillar_f in "${pillar_files[@]}"; do
    if ! [[ -f "$pillar_f" ]]; then
        echo "${pillar_f}:"
        cat <<EOF | tee "$pillar_f"
${jinja_name}:
  multipkgs: []
EOF
    else
        echo "Not writing scaffold pillar file to '$pillar_f' because it already exists"
    fi
done

if [[ -n "$ENV" ]]; then
    echo "Don't forget to add this new package '$jinja_name' to your '$ENV' salt top file!"
fi
