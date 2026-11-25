#!/bin/bash

# Prevent recursive sourcing loops (not exported so subshells/reload still work)
if [ -n "${__DOTFILES_PROFILE_SOURCING:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
__DOTFILES_PROFILE_SOURCING=1

# Machine-specific PATHs, tool envs and other per-system setup
if [ -r ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
  export __DOTFILES_PROFILE_LOCAL_LOADED=1
fi

# One-way flow: login shell sources ~/.bashrc for interactive bash
if [ -n "${BASH_VERSION:-}" ] && [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

unset __DOTFILES_PROFILE_SOURCING
