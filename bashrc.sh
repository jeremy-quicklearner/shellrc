SHRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ETCDIR=$SHRCDIR/etc
mkdir -p $ETCDIR

BASHDIR=$ETCDIR/bash
mkdir -p $BASHDIR

# Functions to change the prompt colour based on exit code of last command
prompt_char() {
    if [ -n "$1" ]; then
        printf "$1"
    elif [[ $UID == 0 ]]; then
        printf "#"
    else
        printf "$"
    fi
}
prompt () {
    if [[ $? == 0 ]]; then
        printf "\1\e[0;0m\2)"$(prompt_char $1)
    else
        printf "\1\e[0;0m\2)\1\e[0;31m\2$(prompt_char $1)\1\e[0;0m\2"
    fi
}

# Debian-like prompt with readline vi mode indicator
if [ $BASH_VERSINFO -ge 5 ] ; then
    preprompt () {
        SUBPS1="\[\e[0;0m\][bash] \[\e[0;32m\]\u@\$JEREMY_HN\[\e[0;0m\]:\[\e[0;34m\]\w\[\e[0;0m\] ("
        bind "set vi-ins-mode-string \"${SUBPS1@P}\1\e[0;32m\2i\""
        bind "set vi-cmd-mode-string \"${SUBPS1@P}\1\e[0;31m\2n\""
    }
    PROMPT_COMMAND=preprompt
    PS1="\$(prompt) "
    PS2="\$(prompt '>') "

# Fallback to simpler prompt if Bash is too old. The vi mode indicator is replaced by xxx
else
    PROMPT_COMMAND=
    PS1="\[\e[0;32m\]\u@\$JEREMY_HN\[\e[0;0m\]:\[\e[0;34m\]\w\[\e[0;0m\] (\e[0;33mx\$(prompt) "
    PS2="\[\e[0;32m\]\u@\$JEREMY_HN\[\e[0;0m\]:\[\e[0;34m\]\w\[\e[0;0m\] (\e[0;33mx\$(prompt '>') "
fi

# Vim is the best text editor
bind "set editing-mode vi"
bind "set show-mode-in-prompt on"
export EDITOR=vim

# Lots of history
HISTSIZE=1000
HISTFILESIZE=10000

# Git auto-complete
source $SHRCDIR/get-bash-git-completion.sh
source $BASHDIR/git-completion.bash

# Simple stuff that works for all shells goes in here
source ~/.shellrc
