#!/bin/bash

# ==============================================================================
# Navigation & System
# ==============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# alias rm='rm -i' # AI forgot pass `-f` every time...!
alias c='clear'
alias reload='source ~/.bash_profile'

# ==============================================================================
# File Listing
# ==============================================================================
if type dircolors > /dev/null 2>&1; then
  if [ -f ~/.dircolors ]; then
    eval "$( dircolors -b ~/.dircolors )"
  elif [ -f $DOTFILES/dircolors ]; then
    eval "$( dircolors -b $DOTFILES/dircolors )"
  fi
fi

if ls --color > /dev/null 2>&1; then
  colorflag="--color"
else
  colorflag="-G"
fi

alias ls="ls $colorflag"
alias dir="dir $colorflag"

if ls --group-directories-first > /dev/null 2>&1; then
    alias lsa='ls -lAhF --group-directories-first'
else
    alias lsa='ls -lAhF'
fi
alias l='lsa'

# ==============================================================================
# Shortcuts (Apps & Utilities)
# ==============================================================================
# Universal Clipboard
if command -v pbcopy > /dev/null 2>&1; then
  alias clip='pbcopy'
elif command -v wl-copy > /dev/null 2>&1; then
  alias clip='wl-copy'
elif command -v xclip > /dev/null 2>&1; then
  alias clip='xclip -selection clipboard'
fi

alias g='git'
alias v='vim'
alias y='yarn'
alias co='code .'

# ==============================================================================
# Docker
# ==============================================================================
alias d='docker'
alias dc='docker compose'
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.Status}}\t{{.Ports}}'"
alias dtop="docker ps --format '{{.Names}}' | xargs docker stats \$1"
alias dclog='dc logs -f --tail'

# ==============================================================================
# Databases
# ==============================================================================
alias pg_start="brew services start postgresql"
alias pg_stop="brew services stop postgresql"
alias mongo_start="brew services start mongodb-community"
alias mongo_stop="brew services stop mongodb-community"

# ==============================================================================
# Git & GitHub CLI
# ==============================================================================
alias gh_merge='gh pr merge -d -m'
alias gh_squash='gh pr merge -d -s'
alias gh_pr='git p; gh pr create -a @me -w -B next'
alias gh_pr_open='gh pr view --web'
alias gh_repo_open='gh repo view --web'
alias gh_ai_review='gh pr comment --body "/gemini review"'

# ==============================================================================
# Yarn
# ==============================================================================
alias ys='yarn start'
alias yp='yarn preview'
alias yw='yarn watch'
alias yd='yarn dev'
alias yb='yarn build'
alias ybp='NODE_ENV=production yarn build'
alias yc='yarn clean'
alias yf='yarn format'
alias yl='yarn lint'
alias yt='yarn test'
alias ycb='yarn clean && yarn build'
alias ycw='yarn clean && yarn watch'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
