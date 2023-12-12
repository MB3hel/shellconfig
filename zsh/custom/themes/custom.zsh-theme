PROMPT="%(?:%{$fg_bold[green]%}%1{➜%}:%{$fg_bold[red]%}%1{➜%})%{$reset_color%}"
if [[ -f /etc/debian_chroot ]]; then
    chroot_name=$(cat /etc/debian_chroot)
    PROMPT+="($chroot_name)"
fi
PROMPT+='$(_omz_theme_prompt_venv)'
PROMPT+="[%{$fg_bold[green]%}%n@%m:%{$fg_bold[blue]%}%1~%{$reset_color%}]"
PROMPT+='$(git_prompt_info)'
PROMPT+="%% "
ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

if type "wslpath" > /dev/null 2>&1; then
    # Required for duplicate tab in windows terminal
    keep_current_path() {
        printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
    precmd_functions+=(keep_current_path)
fi

# Custom prompt part for python venv
# Placed between arrow and rest of prompt
# Also has no space
export VIRTUAL_ENV_DISABLE_PROMPT=1
_omz_theme_prompt_venv(){
    if [ -n "$VIRTUAL_ENV" ]; then
        venv_name="${VIRTUAL_ENV##*/}"
        printf "($venv_name)"
    fi
}
