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
# 2. Modern CLI Tools Registrations (Starship, Zoxide, FZF)
# ==============================================================================

# Starship Prompt
if command -v starship &> /dev/null; then
  eval "$(starship init bash)"
else
  # Clean, standard fallback prompt for servers without Starship (No git needed)
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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
# 3. NVM (Node Version Manager)
# ==============================================================================
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# ==============================================================================
# 4. SSH Agent Auto-Start
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
# 5. Load Secrets
# ==============================================================================
if [ -r ~/.secret.env ]; then
  source ~/.secret.env
fi
