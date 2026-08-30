# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

# Enable system provided completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# In case system configs set anything here
unset CDPATH

# Use arrow keys to search history
bind '"\e[A": history-search-backward' 2>&1
bind '"\e[B": history-search-forward' 2>&1

# Controls behavior of pasting multiple lines
bind 'set enable-bracketed-paste on' 2>&1

# Case insensitive tab completion
bind 'set completion-ignore-case on' 2>&1

# --------------------------------------------------------------------------------------------------
# Custom prompt
# --------------------------------------------------------------------------------------------------

# General settings
unset PROMPT
unset PROMPT_COMMAND # see bash_profile template
PS1='${__PROMPT_ARROW}'

# Alternative to cygpath -w b/c it can be slow if windows defender doesn't exclude msys2 install
# but shell implementation doesn't spawn new processes
__msys_to_winpath(){
    local winpath="${1:1}"                  # remove leading slash
    winpath="${winpath//\//\\}"             # convert '/' to '\\'
    winpath="${winpath^}"                   # Capitalize first letter (drive letter)
    echo "${winpath:0:1}:${winpath:1}"      # First char (drive letter) ':' rest of path
}

# Make duplicate tab work in windows terminal using WSL
if type "wslpath" > /dev/null 2>&1; then
    PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"'
fi

# Make duplicate tab work in windows terminal using MSYS2
if [ "$(uname -o)" = "Msys" ]; then
    PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(__msys_to_winpath "$PWD")"'
fi

__prompt_venv(){
    if [ -n "$VIRTUAL_ENV" ]; then
        if [ -n "$VIRTUAL_ENV_PROMPT" ]; then
            printf "($VIRTUAL_ENV_PROMPT)"
        else
            printf "("${VIRTUAL_ENV##*/}")"
        fi
    fi
}

__prompt_construct(){
    # Set __PROMPT_ARROW based on exit status of last command
    # Green arrow on exit status 0, else red
    if [ $? -ne 0 ]; then
        __PROMPT_ARROW="$(printf "\001\e[01;31m\002→\001\e[00m\002")"
    else
        __PROMPT_ARROW="$(printf "\001\e[01;32m\002→\001\e[00m\002")"
    fi
}
PROMPT_COMMAND="__prompt_construct; $PROMPT_COMMAND"


# Environment prefixes
# MSYS2
if [ -n "$MSYSTEM" ] && [[ "$(cygpath -m '/')" == *scoop* ]]; then
    PS1+="(${MSYSTEM:l})"
fi
# docker / podman containers
if [ -n "$CONTAINER_ID" ]; then
    PS1+="($CONTAINER_ID)"
fi
# schroots
if [[ -f /etc/debian_chroot ]]; then
    chroot_name=$(cat /etc/debian_chroot)
    PS1+="($chroot_name)"
fi
PS1+='$(__prompt_venv)'
VIRTUAL_ENV_DISABLE_PROMPT=1

# Git status for prompt
__prompt_git(){
    # Note: minimize git command invocations because launching git on windows is slow
    # enough to be noticeable. Use one git status command to get all info needed for prompt
    local git_branch=""
    local git_dirty=""
    while read -r line_type line_contents line_contents2; do
        case "$line_type" in 
            '#'*)
                case "$line_contents" in
                    'branch.oid')
                        # First 12 chars of hash
                        git_branch="${line_contents2:0:7}"
                        ;;
                    'branch.head')
                        # Branch name, unless in detached head state (in which case hash is kept)
                        [ "$line_contents2" = "(detached)" ] || git_branch="$line_contents2"
                        ;;
                esac
                ;;
            '1'*|'2'*|'u'*|'?'*)
                git_dirty=" ✗"
                break
                ;;
        esac
    done < <(git status --porcelain=v2 --branch 2>/dev/null)
    [ ! -z "$git_branch" ] && printf "(\001\e[01;36m\002${git_branch}\001\e[01;31m\002${git_dirty}\001\e[00m\002)"
}


# Different color for native windows prompts
PCOLOR="\001\e[32;01m\002"
if [ "$(uname -o)" = "Msys" ]; then
    PCOLOR="\001\e[00;33m\002"
fi
PS1+="[$PCOLOR\u@\h:\001\e[34;01m\002\W\001\e[00m\002]"
PS1+="\$(__prompt_git)"
PS1+="\$ "

# --------------------------------------------------------------------------------------------------


# Configure ls colors
if type dircolors > /dev/null 2>&1; then
    eval `dircolors ~/.shellconfig/dir_colors`
fi

# Load aliases / functions used in both zsh and bash
. ~/.shellconfig/aliases

# Run this once first time bashrc is sourced since prompt command
# is changed in this and arrow is not initially valid
__prompt_construct

