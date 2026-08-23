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

# Custom prompt
autoload -U colors && colors
setopt PROMPT_SUBST
__prompt_arrow(){
    if [ $? -ne 0 ]; then
        printf "%%{\e[01;31m%%}→%%{\e[00m%%}"
    else
        printf "%%{\e[01;32m%%}→%%{\e[00m%%}"
    fi
}
__PROMPT_MSYS_ENVIRONMENT=""
[ -n "$MSYSTEM" ] && [[ "$(cygpath -m '/')" == *scoop* ]] && __PROMPT_MSYS_ENVIRONMENT="(${MSYSTEM:l})"
__prompt_environment(){
    [ -n "$__PROMPT_MSYS_ENVIRONMENT" ] && printf "(${__PROMPT_MSYS_ENVIRONMENT})"
    [ -n "$CONTAINER_ID" ] && printf "(${CONTAINER_ID})"
    [ -n "$VIRTUAL_ENV" ] && printf "(${VIRTUAL_ENV##*/})"
}
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
PCOLOR="$fg_bold[green]"
if [ "$(uname -o)" = "Msys" ]; then
    PCOLOR="$fg[yellow]"
fi
unset PS1 # In case system profile/rc sets this
PROMPT="\$(__prompt_arrow)"
if [[ -f /etc/debian_chroot ]]; then
    chroot_name=$(cat /etc/debian_chroot)
    PROMPT+="($chroot_name)"
fi
PROMPT+="\$(__prompt_environment)"
PROMPT+="[%{$PCOLOR%}%n@%m:%{$fg_bold[blue]%}%1~%{$reset_color%}]"
PROMPT+="\$(__prompt_git)"
PROMPT+="%% "
export VIRTUAL_ENV_DISABLE_PROMPT=1

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
