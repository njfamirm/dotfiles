#!/bin/bash

# Only run in interactive bash shells
[ -n "${BASH_VERSION:-}" ] || return 0 2>/dev/null || exit 0
case $- in
  *i*) ;;
    *) return ;;
esac

# Prevent recursive sourcing loops (not exported so subshells/tmux still load)
if [ -n "${__DOTFILES_BASHRC_SOURCING:-}" ]; then
  return
fi
__DOTFILES_BASHRC_SOURCING=1

# Source system-wide bashrc if present (Linux distros)
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

if [ -f "$DOTFILES/dotfiles.sh" ]; then
  . "$DOTFILES/dotfiles.sh"
fi

# Ensure machine-specific PATHs/envs load in non-login shells (e.g. Linux GUI terminals)
if [ -z "${__DOTFILES_PROFILE_LOCAL_LOADED:-}" ] && [ -r ~/.bash_profile.local ]; then
  . ~/.bash_profile.local
fi

# Optional machine-specific interactive overrides
if [ -r ~/.bashrc.local ]; then
  . ~/.bashrc.local
fi

unset __DOTFILES_BASHRC_SOURCING
