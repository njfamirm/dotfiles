#!/bin/bash

if [ "$BASH" ]; then
  export DOTFILES=~/dotfiles

  if [ -f $DOTFILES/dotfiles.sh ]; then
    . $DOTFILES/dotfiles.sh
  fi

  # Uncoment the following lines if you want to load ~/.bashrc too
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

# Machine-specific PATHs, tool envs and other per-system setup
if [ -r ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi
