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

# Used to search history with up/down keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Keybinds (mostly based on debian's settings)
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search    2>/dev/null # Up
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search  2>/dev/null # Down
bindkey "${terminfo[kcub1]}" backward-char                  2>/dev/null # Left
bindkey "${terminfo[kcuf1]}" forward-char                   2>/dev/null # Right
bindkey "${terminfo[kbs]}"   backward-delete-char           2>/dev/null # Backspace
bindkey "${terminfo[kdch1]}" delete-char                    2>/dev/null # Del
bindkey "${terminfo[kich1]}" overwrite-mode                 2>/dev/null # Insert
bindkey "${terminfo[khome]}" beginning-of-line              2>/dev/null # Home
bindkey "${terminfo[kend]}"  end-of-line                    2>/dev/null # End
bindkey "${terminfo[kLFT5]}" backward-word                  2>/dev/null # Ctrl+Left
bindkey "${terminfo[kRIT5]}" forward-word                   2>/dev/null # Ctrl+Right

# Put terminal in application mode while zle active so that terminfo values valid
function zle-line-init () {
    emulate -L zsh
    printf '%s' ${terminfo[smkx]}
}
function zle-line-finish () {
    emulate -L zsh
    printf '%s' ${terminfo[rmkx]}
}
zle -N zle-line-init
zle -N zle-line-finish


# --------------------------------------------------------------------------------------------------
# Custom prompt
# --------------------------------------------------------------------------------------------------

# General settings
autoload -U colors && colors
setopt PROMPT_SUBST
unsetopt promptcr
PS1=""
unset PROMPT # In case system profile/rc sets this


# Make duplicate tab work in windows terminal using WSL
if type "wslpath" > /dev/null 2>&1; then
    __wt_dup_path() {
        printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
    precmd_functions+=(__wt_dup_path)
fi

# Make duplicate tab work in windows terminal using MSYS2
if [ "$(uname -o)" = "Msys" ]; then
    __wt_dup_path() {
        printf "\e]9;9;%s\e\\" "$(cygpath -w "$PWD")"
    }
    precmd_functions+=(__wt_dup_path)
fi


# Red or green arrow at start of prompt (using precmd functions so it is printed before prompt)
__prompt_arrow(){
    if [ $? -ne 0 ]; then
        print -nP "%{\e[01;31m%}→%{\e[00m%}"
    else
        print -nP "%{\e[01;32m%}→%{\e[00m%}"
    fi
}
precmd_functions+=(__prompt_arrow)


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
# python venvs
VIRTUAL_ENV_DISABLE_PROMPT=1
PS1+='${VIRTUAL_ENV:+(${${VIRTUAL_ENV//\\//}##*/})}'

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
    [ ! -z "$git_branch" ] && printf "(%%{\e[01;36m%%}${git_branch}%%{\e[01;31m%%}${git_dirty}%%{\e[00m%%})"
}


# Different color for native windows prompts
PCOLOR="$fg_bold[green]"
if [ "$(uname -o)" = "Msys" ]; then
    PCOLOR="$fg[yellow]"
fi
PS1+="[%{$PCOLOR%}%n@%m:%{$fg_bold[blue]%}%1~%{$reset_color%}]"
PS1+="\$(__prompt_git)"
PS1+="%% "

# --------------------------------------------------------------------------------------------------


# Configure ls colors
if type dircolors > /dev/null 2>&1; then
    eval `dircolors ~/.shellconfig/dir_colors`
fi

# Load aliases / functions used in both zsh and bash
. ~/.shellconfig/aliases

