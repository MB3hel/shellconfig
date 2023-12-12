#! bash oh-my-bash.module

PS1="\$(_omb_theme_prompt_arrow)"
if [[ -f /etc/debian_chroot ]]; then
    chroot_name=$(cat /etc/debian_chroot)
    PS1+="($chroot_name)"
fi
# TODO: venv
PS1+="[${_omb_prompt_bold_green}\u@\h:${_omb_prompt_bold_navy}\W${_omb_term_reset_color}${_omb_term_normal}]"
PS1+="\$(scm_prompt_info)"
PS1+="\$ "

SCM_THEME_PROMPT_PREFIX="(${_omb_prompt_cyan}"
SCM_THEME_PROMPT_SUFFIX="${_omb_term_reset_color}${_omb_term_normal})"
SCM_THEME_PROMPT_DIRTY=" ${_omb_prompt_red}✗"
SCM_THEME_PROMPT_CLEAN=""

function _omb_theme_prompt_arrow {
    if [ $? -ne 0 ]; then
        echo "${_omb_term_bold_red}➜${_omb_term_reset_color}${_omb_term_normal}"
    else
        echo "${_omb_term_bold_green}➜${_omb_term_reset_color}${_omb_term_normal}"
    fi
}
