#!/bin/bash

# If $BASH not defined, don't do anything
if [ -z "$BASH" ]; then
  return
fi

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

if [ -z "$DOTFILES" ]; then
  export DOTFILES='~/dotfiles'
fi

for i in $DOTFILES/dotfiles.d/*.sh; do
  if [ -r $i ]; then
    . $i
  fi
done
unset i

export PATH="$DOTFILES/bin:$PATH"
