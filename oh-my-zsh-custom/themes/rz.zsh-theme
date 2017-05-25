# rz.zsh-theme
#
# Minimal shell prompts.
#
# Main                                      Right
# [hostname] [path] [prompt_string] ...     [dirty] [branch] | ([12hr time])
#
# Branch icon requires powerline-patched fonts.

#
# Colors
#
CYAN="%{$fg[cyan]%}"
GREEN="%{$fg[green]%}"
YELLOW="%{$fg[yellow]%}"
MAGENTA="%{$fg[magenta]%}"
RED="%{$fg[red]%}"
RESET="%{$reset_color%}"

#
# Git setup
#
ZSH_THEME_GIT_PROMPT_PREFIX="${RESET}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY="${YELLOW}* ${RESET}"
ZSH_THEME_GIT_PROMPT_CLEAN="${RESET}"

git_custom_prompt () {
  local branch=$(current_branch)
  if [ -n "${branch}" ]; then
    # parse_git_dirty echoes PROMPT_DIRTY or PROMPT_CLEAN (.oh-my-zsh/lib/git.zsh)
    echo "$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

virtual_env_custom_prompt () {
  [ $VIRTUAL_ENV ] && echo "$YELLOW("`basename $VIRTUAL_ENV`")$RESET"
}

#
# Main prompt
#
local host_name="${MAGENTA}λ"
local path_string="${YELLOW}~"
local prompt_string="»"
local return_status="%(?:${GREEN}${prompt_string}:${RED}${prompt_string})"
PROMPT="${host_name} ${path_string} ${return_status} "

#
# Right Prompt
#
RPROMPT="$(virtual_env_custom_prompt) $(git_custom_prompt)"
