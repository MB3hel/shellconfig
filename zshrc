# Source global definitions
if [ -f /etc/zsh/zshrc ]; then
    . /etc/zsh/zshrc
fi
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi

# Preserve history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Tab completion (using oh-my-zsh's completion.zsh)
autoload -Uz compinit && compinit
source ~/.shellconfig/completion.zsh

# Search history with up/down keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

# Home & end keys
bindkey "^[OH" beginning-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[F" end-of-line

# Custom prompt
autoload -U colors && colors
setopt PROMPT_SUBST
__prompt_arrow(){
    if [ $? -ne 0 ]; then
        local c="\e[01;31m"
    else
        local c="\e[01;32m"
    fi
    printf "%%{${c}%%}→%%{\e[00m%%}"
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
        printf "(%%{\e[01;36m%%}${git_branch}%%{\e[00m%%}%%{\e[01;31m%%}${git_dirty}%%{\e[00m%%})"
    fi
}
PCOLOR="$fg_bold[green]"
if [ "$(uname -o)" = "Msys" ]; then
    PCOLOR="$fg[yellow]"
fi
unset PS1
PROMPT="\$(__prompt_arrow)"
if [[ -f /etc/debian_chroot ]]; then
    chroot_name=$(cat /etc/debian_chroot)
    PROMPT+="($chroot_name)"
fi
PROMPT+="\$(__prompt_venv)"
PROMPT+="[%{$PCOLOR%}%n@%m:%{$fg_bold[blue]%}%1~%{$reset_color%}]"
PROMPT+="\$(__prompt_git)"
PROMPT+="%% "

# Configure ls colors
if type dircolors > /dev/null 2>&1; then
    eval `dircolors ~/.shellconfig/dir_colors`
fi

# Load aliases / functions used in both zsh and bash
. ~/.shellconfig/aliases

# Make duplicate tab work in windows terminal using WSL
if type "wslpath" > /dev/null 2>&1; then
    keep_current_path() {
        printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
    precmd_functions+=(keep_current_path)
fi

# Make duplicate tab work in windows terminal using MSYS2
if [ "$(uname -o)" = "Msys" ]; then
    keep_current_path() {
        printf "\e]9;9;%s\e\\" "$(cygpath -w "$PWD")"
    }
    precmd_functions+=(keep_current_path)
fi


