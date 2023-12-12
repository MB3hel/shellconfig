#! bash oh-my-bash.module

# Note: Use _omb_prompt_... in PS1
# If ehco / printf ing use _omb_term_...
# Note: If echoing using _omb_term... need to add \001 to start and \002 to end
# Ex:
#   - PS1="${_omb_prompt_red}thing${_omb_prompt_reset_color}"
#   - PS1="\$(myfunc)"
#   - In myfunc: echo "\001${_omb_term_red}\002thing\001${_omb_term_reset}\002"
# Don't need \001 and \002 outside of things that go into prompt!
# Why:
# readline requires \[COLOR_STUFF_HERE\] in PS1 to determine proper line width
# \[ = \001 and \] = \002 but \[ and \] only work directly in PS1 not in echo
# So echo needs to output \001 and \002 around color settings

PS1="\$(_omb_theme_prompt_arrow)"
if [[ -f /etc/debian_chroot ]]; then
    chroot_name=$(cat /etc/debian_chroot)
    PS1+="($chroot_name)"
fi
# TODO: venv
PS1+="[${_omb_prompt_bold_green}\u@\h:${_omb_prompt_bold_navy}\W${_omb_prompt_normal}]"
PS1+="\$(scm_prompt_info)"
PS1+="\$ "

# These are echoed. Use _term colors and make sure to use \001 and \002 as described above!
SCM_THEME_PROMPT_PREFIX="(\001${_omb_term_bold}\002\001${_omb_term_teal}\002" 
SCM_THEME_PROMPT_SUFFIX="\001${_omb_term_reset}\002)"
SCM_THEME_PROMPT_DIRTY=" \001${_omb_term_red}\002✗"
SCM_THEME_PROMPT_CLEAN=""
SCM_GIT_SHOW_MINIMAL_INFO=true

function _omb_theme_prompt_arrow {
    if [ $? -ne 0 ]; then
        echo -ne "\001${_omb_term_bold}\002\001${_omb_term_red}\002➜\001${_omb_term_reset}\002"
    else
        echo -ne "\001${_omb_term_bold}\002\001${_omb_term_green}\002➜\001${_omb_term_reset}\002"
    fi
}
