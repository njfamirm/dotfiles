#!/bin/bash

git clone --bare https://github.com/njfamirm/dotfiles ~/.dotfiles
function dtf {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
dtf checkout --force
if [ $? = 0 ]; then
  echo "Checked out config.";
else
  echo "Backing up pre-existing dot files.";
fi;
dtf config status.showUntrackedFiles no

# Install packages with apt
if type apt-get > /dev/null; then
   sudo apt-get update
   sudo apt-get -y install tmux vim git
fi

# Install oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh)
if [ ! -d ~/.oh-my-zsh ];then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
