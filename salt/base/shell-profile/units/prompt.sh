# Customizes the Zsh prompt

# Default to supershort being enabled
SHELL_PROFILE_PROMPT_SUPERSHORT=

is_dumb() {
    if [[ "$TERM" == "dumb" ]]; then
	   return $(true)
    fi

    return $(false)
}

is_no_color() {
    if is_dumb || [[ -n "$SHELL_UNIT_PROMPT_NO_COLOR" ]]; then
	   return $(true)
    fi

    return $(false)
}

# Colors
# From: https://stackoverflow.com/a/20983251
color_tput() { # ( args... )
    if ! is_no_color; then
	   tput "$@"
    fi
}

color_reset() {
    color_tput sgr0
}

color_bg_red() {
    color_tput setab 1
}

color_bg_default() {
    color_tput setab 245
}



color_fg_white() {
    color_tput setaf 255
}

color_fg_green() {
    color_tput setaf 2
}

color_fg_blue() {
    color_tput setaf 4
}

color_fg_magenta() {
    color_tput setaf 5
}

color_fg_red() {
    color_tput setaf 1
}

shell-no-color() {
    color_reset
    
    if [ -z "$SHELL_UNIT_PROMPT_NO_COLOR" ]; then
	SHELL_UNIT_PROMPT_NO_COLOR=true
    else
	SHELL_UNIT_PROMPT_NO_COLOR=""
    fi

    echo "SHELL_UNIT_PROMPT_NO_COLOR=$SHELL_UNIT_PROMPT_NO_COLOR"

    build_prompt
}

# Prints a check or an x depending on the exit status of the last command.
# Takes an exist status as an argument and outputs a prompt for that status. It is
# required as an argument bc the exit status for the last command the user runs
# will be overriden by the exit status's of other internal prompt building functions
# like this one.
exit_status_prompt() { # ( Exit status )
    if [[ "$1" != "0" ]]; then
	   echo "$(color_fg_red)$1$(color_reset) "
    fi
}

# Prints git:BRANCH to prompt if in git directory.
# If SHELL_PROFILE_PROMPT_SUPERSHORT is set nothing
# will show.
git_prompt() {
	label_txt="git:"
	if [ -z "$SHELL_PROFILE_PROMPT_SUPERSHORT" ]; then
	    # Get current branch
	    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)

	    if [[ "$?" != "0" ]]; then # Probably not in Git repository
		   return 0
	    fi

	    echo "$(color_fg_green)git:$(color_fg_magenta)$branch"
	fi
}

user_symbol() {
    if [ "$UID" -eq 0 ]; then
	   echo "#"
    else
	   echo "%"
    fi
}

# Sets prompt variable
build_prompt() {
    # Capture the last cmd's exit status before we run internal prompt building
    # functions. This will be passed to exit_status_prompt()
    last_cmd_exit_status="$?"
    
    # If a dumb terminal (ex., Emacs TRAMP) then don't do anything fancy
    if is_dumb; then
	   export PS1="%# "
	   return
    fi
    
    # EXIT_STATUS HOSTNAME PATH git:BRANCH %#
    export PS1="[$(exit_status_prompt $last_cmd_exit_status)\h \W] $(user_symbol) "
    #export PS1="$(exit_status_prompt $last_cmd_exit_status)$(pwd_prompt) $(git_prompt) $(color_fg_white)${newline_end}$(user_symbol) "
}

source {{ pillar.bash.preexec.file }}
npreexec () {
    # Do nothing
    :;
}
precmd() {
    build_prompt
}
build_prompt

