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

echoStep '🎉 Done'
