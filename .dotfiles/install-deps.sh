# Install packages with apt
if type apt > /dev/null; then
   sudo apt-get -y install tmux vim git
fi

# Install oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
