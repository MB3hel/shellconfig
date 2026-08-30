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

# Fix tab completion of msys unix style paths
if [ "$(uname -o)" = "Msys" ]; then
    zstyle ':completion:*' fake-files /: "/:$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')"
fi

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
PS1=""
unset PROMPT # In case system profile/rc sets this


if type "wslpath" > /dev/null 2>&1; then
    # Make duplicate tab work in windows terminal using WSL
    __wt_dup_path() {
        printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
fi
if [ "$(uname -o)" = "Msys" ]; then
    # Alternative to cygpath -w b/c it can be slow if windows defender doesn't exclude msys2 install
    # but shell implementation doesn't spawn new processes
    __msys_to_winpath(){
        local winpath="${1:1}"                  # remove leading slash
        winpath="${winpath//\//\\\\}"           # convert '/' to '\\'
        echo "${(C)winpath:0:1}:${winpath:1}" # First char (drive letter caps) ':' rest of path
    }
    # Make duplicate tab work in windows terminal using MSYS2
    __wt_dup_path() {
        printf "\e]9;9;%s\e\\" "$(__msys_to_winpath "$PWD")"
    }
fi
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
    [ ! -z "$git_branch" ] && PS1+="(%{$fg_bold[cyan]%}${git_branch}%{$fg_bold[red]%}${git_dirty}%{$reset_color%})"
}
__prompt_environment(){
    [ -n "$CONTAINER_ID" ] && PS1+="($CONTAINER_ID)"
    [ -n "$__DEB_CHROOT" ] && PS1+="($__DEB_CHROOT)"
    [ -n "$__MSYS_ENV" ] && PS1+="($__MSYS_ENV)"
    if [ -n "$VIRTUAL_ENV" ]; then
        if [ -n "$VIRTUAL_ENV_PROMPT" ]; then
            PS1+="($VIRTUAL_ENV_PROMPT)"
        else
            PS1+="($(basename "$VIRTUAL_ENV"))"
        fi
    fi
}
__prompt_construct(){
    # Set __PROMPT_ARROW based on exit status of last command
    # Green arrow on exit status 0, else red
    if [ $? -ne 0 ]; then
        PS1="%{$fg_bold[red]%}→%{$reset_color%}"
    else
        PS1="%{$fg_bold[green]%}→%{$reset_color%}"
    fi
    __wt_dup_path 2>/dev/null || true
    __prompt_environment 
    PS1+="[%{$PCOLOR%}%n@%m:%{$fg_bold[blue]%}%1~%{$reset_color%}]"
    __prompt_git
    PS1+="%% "
}
precmd_functions=(__prompt_construct $precmd_functions)


# Static environment prefixes
if [ -n "$MSYSTEM" ] && [[ "$(cygpath -m '/')" == *scoop* ]]; then
    __MSYS_ENV="(${MSYSTEM:l})" # Cache this to avoid repeated cygpath
fi
if [[ -f /etc/debian_chroot ]]; then
    __DEB_CHROOT="($chroot_name)" # Cahce this to avoid repeated file reads
fi
VIRTUAL_ENV_DISABLE_PROMPT="1"


# Different color for native windows prompts
PCOLOR="$fg_bold[green]"
if [ "$(uname -o)" = "Msys" ]; then
    PCOLOR="$fg[yellow]"
fi

# --------------------------------------------------------------------------------------------------


# Configure ls colors
if type dircolors > /dev/null 2>&1; then
    eval `dircolors ~/.shellconfig/dir_colors`
fi

# Load aliases / functions used in both zsh and bash
. ~/.shellconfig/aliases

