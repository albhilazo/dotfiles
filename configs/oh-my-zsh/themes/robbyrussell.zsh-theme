# Custom theme based on the default "robbyrussel".

local ret_status="%(?:%{$fg_bold[grey]%}>>:%{$fg_bold[red]%}>>%s)"
PROMPT='%{$fg[gray]%}%T %{$fg_bold[cyan]%}%3~ ${ret_status}%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
