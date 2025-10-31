# Set EDITOR so programs know which editor to open files in

# Open emacs client in existing Emacs window, since this should be running in Emacs
# in ansi-term by the inferior shell bash.
export EDITOR="emacsclient -c"
#--alternate-editor=''"
