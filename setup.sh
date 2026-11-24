#!/bin/bash

set -Eeuo pipefail

clear

DOTFILES=${DOTFILES:-"$HOME/dotfiles"}
BACKUP_DIR="$DOTFILES/backup"

function echoStep() {
  echo -e "\n\033[1;32m$1\033[0m"
}

function createSymlink() {
  local sourceFile=$1
  local destinationFile=$2

  echo "Creating symbolic link from $sourceFile to $destinationFile"

  if [ -e "$destinationFile" ] && [ ! -L "$destinationFile" ]; then
    echo "File $destinationFile already exists, creating a backup..."
    mv $destinationFile $BACKUP_DIR/
  fi

  ln -svf $sourceFile $destinationFile
}

# ---

echo -ne "\033[1;33m💎 Setting up dotfiles\033[0m\n"

# Clone or update dotfiles

if [ -d "$DOTFILES" ]; then
  echo '✌🏻 dotfiles already exists, updating...'
  cd $DOTFILES
  git pull --prune --progress --autostash --rebase
else
  echo '✌🏻 dotfiles does not exist, cloning...'
  git clone https://github.com/njfamirm/dotfiles $DOTFILES
fi

# Create symbolic links

echoStep '🔗 Creating symbolic links...'
mkdir -p $BACKUP_DIR
createSymlink $DOTFILES/bash_profile.sh ~/.bash_profile
createSymlink $DOTFILES/gitconfig ~/.gitconfig
createSymlink $DOTFILES/config/.vimrc ~/.vimrc
createSymlink $DOTFILES/config/tmux.conf ~/.tmux.conf

mkdir -p ~/.config
createSymlink $DOTFILES/config/starship.toml ~/.config/starship.toml

# OpenCode (global config, commands and plugins live in this repo)

echoStep '🤖 Linking OpenCode config...'
mkdir -p ~/.config/opencode/command ~/.config/opencode/plugins
createSymlink "$DOTFILES/config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
for f in "$DOTFILES"/config/opencode/command/*.md; do
  [ -e "$f" ] || continue
  createSymlink "$f" "$HOME/.config/opencode/command/$(basename "$f")"
done
for f in "$DOTFILES"/config/opencode/plugins/*; do
  [ -e "$f" ] || continue
  createSymlink "$f" "$HOME/.config/opencode/plugins/$(basename "$f")"
done
# NOTE: ~/.config/opencode/service.json is machine-specific and stays untracked.

# Create machine-specific overrides from templates (never tracked by git)

echoStep '🖥️  Creating local override files...'
if [ ! -e ~/.gitconfig.local ] && [ -f "$DOTFILES/gitconfig.local.example" ]; then
  cp "$DOTFILES/gitconfig.local.example" ~/.gitconfig.local
  echo "Created ~/.gitconfig.local — set your signingkey or disable gpgsign"
fi
if [ ! -e ~/.bash_profile.local ] && [ -f "$DOTFILES/bash_profile.local.example" ]; then
  cp "$DOTFILES/bash_profile.local.example" ~/.bash_profile.local
  echo "Created ~/.bash_profile.local"
fi

echoStep '🎉 Done'
