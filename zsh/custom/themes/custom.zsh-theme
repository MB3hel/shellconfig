PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} )%{$reset_color%}[%{$fg_bold[green]%}%n@%m:%{$fg_bold[blue]%}%1~%{$reset_color%}]"
PROMPT+=' $(git_prompt_info)'
PROMPT+="%% "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}%1{✗%}%{$fg[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%})"
