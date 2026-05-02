#!/bin/bash

# ==============================================================================
# 1. Shell Configurations (History, Window Size, etc.)
# ==============================================================================
HISTCONTROL=ignoreboth
shopt -s histappend
HISTFILESIZE=99999999
HISTSIZE=99999999
shopt -s checkwinsize

# ==============================================================================
# 2. Colors & ls Configuration
# ==============================================================================
if type dircolors > /dev/null 2>&1; then
  if [ -f ~/.dircolors ]; then
    eval "$( dircolors -b ~/.dircolors )"
  elif [ -f $ONE_BASH/dircolors ]; then
    eval "$( dircolors -b $ONE_BASH/dircolors )"
  fi
fi

if ls --color > /dev/null 2>&1; then
  colorflag="--color"
else
  colorflag="-G"
fi
alias ls="ls $colorflag"
alias dir="dir $colorflag"

# ==============================================================================
# 3. Modern CLI Tools Registrations (Starship, Zoxide, FZF)
# ==============================================================================

# Starship Prompt
if command -v starship &> /dev/null; then
  eval "$(starship init bash)"
else
  PS1="\[\033]0;\w\007\]\n\[\e[1;33m\]$USER \[\e[1;37m\]at \[\e[1;36m\]$HOSTNAME \[\e[1;37m\]in \[\e[1;31m\]\w\n\[\e[1;37m\]\$ \[\e[0m\]"
fi

# Zoxide (Better cd)
if command -v zoxide > /dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# FZF (Fuzzy Finder) - Commented out temporarily per your request
# if command -v fzf > /dev/null 2>&1; then
#   eval "$(fzf --bash)"
# fi

# ==============================================================================
# 4. NVM (Node Version Manager) Lazy Loading
# ==============================================================================
export NVM_DIR="$HOME/.nvm"
_lazy_load_nvm() {
  unset -f nvm node npm npx yarn pnpm corepack
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
for cmd in nvm node npm npx yarn pnpm corepack; do
  eval "${cmd}() { _lazy_load_nvm; ${cmd} \"\$@\"; }"
done

# ==============================================================================
# 5. SSH Agent Auto-Start
# ==============================================================================
export SSH_AUTH_SOCK=$HOME/.ssh/auth_sock
export SSH_AGENT_PID=''
SSH_AGENT_INFO=$HOME/.ssh/agent_info

if [[ -f $SSH_AGENT_INFO ]]; then
  source $SSH_AGENT_INFO > /dev/null 2>&1
fi

if [[ -f ~/.ssh/id_rsa || -f ~/.ssh/id_ed25519 ]]; then
  if ! ssh-add -l > /dev/null 2>&1; then
    [ -n "$SSH_AGENT_PID" ] && ssh-agent -k > /dev/null 2>&1
    [ -e "$SSH_AUTH_SOCK" ] && rm -f $SSH_AUTH_SOCK
    [ -e "$SSH_AGENT_INFO" ] && rm -f $SSH_AGENT_INFO

    ssh-agent -a "$SSH_AUTH_SOCK" -s > $SSH_AGENT_INFO
    source $SSH_AGENT_INFO > /dev/null 2>&1
    ssh-add > /dev/null 2>&1
  fi
fi

# ==============================================================================
# 6. Load Secrets
# ==============================================================================
if [ -r ~/.secret.env ]; then
  source ~/.secret.env
fi
