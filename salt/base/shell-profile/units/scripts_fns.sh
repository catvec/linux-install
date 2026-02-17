# Load script repository functions into shell

# Load script repository functions into shell
files=($($HOME/{{ pillar.scripts_repo.home_relative_dir }}/load-functions.sh))

for file in "${files[@]}"; do
    . "$file"
done
