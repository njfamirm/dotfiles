alias cp='cp -i'
alias df='df -h'
alias free='free -m' # show sizes in MB
alias more="less"
alias y='yarn'
alias g="git"
alias mkdir="mkdir -p"
alias d=docker
alias doc=docker-compose
alias wd=windscribe
alias wdc="wd connect"
alias wdd="wd disconnect"
alias c=clear
alias code=code-insiders
alias q="tmux detach-client"
alias e="exit"
alias s=sudo
alias ls="ls --color='auto'"
alias lsa="ls -a --color='auto'"
alias ll="ls -ltrh --color='auto'"
alias m=make
alias tm="tmux"
alias reload="source ~/.zshrc"
alias v=vim
alias cdl="cd -"

function mkd() {
  mkdir -p "$1";
  cd "$1";
}

alias dtf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Config file
alias zshconf="vim ~/.zshrc"
alias tmuxconf="vim ~/.tmux.conf"
alias vimconf="vim ~/.vimrc"
alias gitconf="vim ~/.gitconfig"
