#!/usr/bin/env bash

###############################################################################
# Path
###############################################################################

# Add user bin
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/bin:/usr/local/opt/ruby/bin:$PATH"

###############################################################################
# Misc.
###############################################################################

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

###############################################################################
# Functions
###############################################################################

#!/bin/bash

countdown () {
  local n="$1"
  while [[ $n -gt 0 ]]; do
    printf "\r\033[0K==> $n"
    sleep 1
    ((n--))
  done
  printf "\r"
}

###############################################################################
# Aliases
###############################################################################

alias nanobash='nano ~/.bashrc'
alias sourcebash='source ~/.bashrc'
alias cddev='cd ~/Developer'
alias ls='ls -G'
alias la='ls -A'