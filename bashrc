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

# Custom prompt
__prompt_arrow(){
    if [ $? -ne 0 ]; then
        local c="\e[01;31m"
    else
        local c="\e[01;32m"
    fi
    echo -ne "\001${c}\002→\001\e[00m\002"
}
__prompt_venv(){
    local venv_name=""
    if [ -n "$VIRTUAL_ENV" ]; then
        venv_name="${VIRTUAL_ENV##*/}"
        printf "($venv_name)"
    fi
}
__prompt_git(){
    # symbolic-ref will work for branch names (even with no commits), but not 
    # detached head. Fallback to rev-parse which will work for detached head
    local git_branch="$(git symbolic-ref --short HEAD 2> /dev/null)"
    if [ -z "$git_branch" ]; then
        git_branch="$(git rev-parse --short HEAD 2> /dev/null)"
    fi
    local git_dirty=""
    if [ ! -z "$git_branch" ]; then
        git_dirty="$([[ -z $(git status --porcelain 2> /dev/null) ]] || printf " ✗")"
        printf "(\001\e[01;36m\002${git_branch}\001\e[00m\002\001\e[01;31m\002${git_dirty}\001\e[00m\002)"
    fi
}
PCOLOR="\001\e[32;01m\002"
if [ "$(uname -o)" = "Msys" ]; then
    PCOLOR="\001\e[00;33m\002"
fi
PS1="\$(__prompt_arrow)"
PS1+="\$(__prompt_venv)"
PS1+="[$PCOLOR\u@\h:\001\e[34;01m\002\W\001\e[00m\002]"
PS1+="\$(__prompt_git)"
PS1+="\$ "
export VIRTUAL_ENV_DISABLE_PROMPT=1
unset PROMPT

# Configure ls colors
if type dircolors > /dev/null 2>&1; then
    eval `dircolors ~/.shellconfig/dir_colors`
fi

# Load aliases / functions used in both zsh and bash
. ~/.shellconfig/aliases

# Make duplicate tab work in windows terminal using WSL
if type "wslpath" > /dev/null 2>&1; then
    PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"'
fi

# Make duplicate tab work in windows terminal using MSYS2
if [ "$(uname -o)" = "Msys" ]; then
    PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(cygpath -w "$PWD")"'
fi

