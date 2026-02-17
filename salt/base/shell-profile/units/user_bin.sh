# Add directories in $HOME/bin and $HOME/.local/bin to the PATH

home_bin="$HOME/.local/bin/"

# Add all top level directories in bin
while read -r d; do
    PATH="$PATH:$d"
done <<< $(find "$home_bin" -maxdepth 1 ! -path . -type d)

PATH="$PATH:$HOME/.local/bin"
