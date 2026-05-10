#!/bin/bash

if [ "$BASH" ]; then
  export DOTFILES=~/dotfiles

  if [ -f $DOTFILES/dotfiles.sh ]; then
    . $DOTFILES/dotfiles.sh
  fi

  # Uncoment the following lines if you want to load ~/.bashrc too
  # if [ -f ~/.bashrc ]; then
  #   . ~/.bashrc
  # fi
fi

