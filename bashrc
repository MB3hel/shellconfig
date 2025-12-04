####################################################################################################
# General setup (based on Ubuntu & Fedora default .bashrc)
####################################################################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

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

# Default settings
export EDITOR="nvim"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Use arrow keys to search history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

####################################################################################################



####################################################################################################
# Custom prompt & Colors
####################################################################################################
__prompt_arrow(){
    if [ $? -ne 0 ]; then
        echo -ne "\001\e[01m\002\001\e[31m\002→\001\e[00m\002"
    else
        echo -ne "\001\e[01m\002\001\e[32m\002→\001\e[00m\002"
    fi
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
PS1="\$(__prompt_arrow)"
PS1+="\$(__prompt_venv)"
PS1+="[\001\e[32;01m\002\u@\h:\001\e[34;01m\002\W\001\e[00m\002]"
PS1+="\$(__prompt_git)"
PS1+="\$ "
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PS1
unset PROMPT

# dircolors
if type dircolors > /dev/null 2>&1 && [ -f ~/.shellconfig/dir_colors ]; then
    eval `dircolors ~/.shellconfig/dir_colors`
fi

####################################################################################################



####################################################################################################
# Aliases & Functions
####################################################################################################
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias open='xdg-open'
alias trash='gio trash'

# Pickup changes to SSH agent when attaching to tmux from new login
# This does nothing on windows. SSH_AUTH_SOCK not used on windows
fixssh(){
    if [ "$(uname -o)" != "Msys" ]; then
        eval `tmux showenv -s SSH_AUTH_SOCK`
        eval `tmux showenv -s SSH_AGENT_PID`
    fi
}

####################################################################################################

