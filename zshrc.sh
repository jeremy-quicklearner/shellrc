SHRCDIR="$( cd "$( dirname "${(%):-%N}" )" >/dev/null 2>&1 && pwd )"
ETCDIR=$SHRCDIR/etc
mkdir -p $ETCDIR

ZSHDIR=$ETCDIR/zsh
mkdir -p $ZSHDIR

FPATHDIR=$ZSHDIR/fpath
mkdir -p $FPATHDIR
fpath=($FPATHDIR $fpath)

# Debian-like prompt with vi mode indicator
# https://stackoverflow.com/questions/39871079/detect-zsh-keymap-mode-for-vi-visual-mode
ZLE_KEYMAP="%F{green}i%f"
function line_pre_redraw {
    local prev_keymap="${ZLE_KEYMAP}"

    case "${KEYMAP}" in
        vicmd)
            case "${REGION_ACTIVE}" in
                1)
                    ZLE_KEYMAP="%F{red}v%f"
                    ;;
                2)
                    ZLE_KEYMAP="%F{red}v%f"
                    ;;
                *)
                    ZLE_KEYMAP="%F{red}n%f"
                    ;;
            esac
            ;;
        viins|main)
            if [[ "${ZLE_STATE}" == *overwrite* ]]; then
                ZLE_KEYMAP="%F{yellow}r%f"
            else
                ZLE_KEYMAP="%F{green}i%f"
            fi
            ;;
    esac

    if [[ "${ZLE_KEYMAP}" != "${prev_keymap}" ]]; then
        zle reset-prompt
    fi
}
autoload -U add-zle-hook-widget
add-zle-hook-widget zle-line-pre-redraw line_pre_redraw
setopt prompt_subst
PS1='%f[zsh] %F{green}%n@$JEREMY_HN%f:%F{blue}%~%f ($ZLE_KEYMAP)%(?..%F{red})%(!.#.$)%f '
PS2='%f[zsh] %F{green}%n@$JEREMY_HN%f:%F{blue}%~%f ($ZLE_KEYMAP)%(?..%F{red})>%f '
zle_highlight=(region:bg=red)

# Vim is the best text editor
export EDITOR=vim
bindkey -v
# But I like Ctrl-R
bindkey '^R' history-incremental-search-backward

# Lots of history
HISTSIZE=1000
SAVEHIST=10000

# Git auto-complete
# zsh script depends on bash script
$SHRCDIR/get-bash-git-completion.sh
zstyle ':completion:*:*:git:*' script $ETCDIR/bash/git-completion.bash
if [ ! -f $FPATHDIR/_git ]; then
    echo "Downloading git-completion.zsh..."
    curl -L https://github.com/git/git/raw/master/contrib/completion/git-completion.zsh > $FPATHDIR/_git
    chmod a+x $FPATHDIR/_git
fi

# Enable completion
autoload -Uz compinit; compinit

# fg \d
fg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin fg %-
    else
        builtin fg %"$@"
    fi
}

# Simple stuff that works for all shells goes in here
source ~/.shellrc
