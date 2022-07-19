export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode reminder

source $ZSH/oh-my-zsh.sh

# Tmux plugin config
ZSH_TMUX_AUTOSTART=true

DOTFILES=~/.dotfiles
for config_file ("$DOTFILES"/dotfiles.d/**/*.*sh); do
  source "$config_file"
done
unset config_file

# zsh-z
set $_Z_MAX_SCORE 1000
autoload -U compinit && compinit

# prompt

set_prompt_symbol() {
  if [ $EUID -ne "0" ]; then
    echo "%F{#c5c5b6}$"
  else
    echo "%F{#c5c5b6}#"
  fi
}

short_pwd() {
  pwd="${${(s:/:)PWD}[-2]}/${PWD:t}"
  if [ "$PWD" = "$HOME" ]
  then
    pwd='~'
  fi
  echo "$pwd"
}

get_ip() {
 if [ -n "$SSH_CLIENT" ]; then

   ip="$(curl -s -m 1 ifconfig.co 2>/dev/null)"
   if [ "$ip" != "" ]; then
     echo "%F{#c5c5b6} in %F{#55a630}$ip"
   fi
 fi
}

PROMPT="%F{#fcf300}%n$(get_ip) %F{#c5c5b6}at %F{#ccff33}"'$(short_pwd)'"%F{reset_color} "'$(set_git_prompt)'$'\n'"$(set_prompt_symbol)%F{reset_color} "
PROMPT2="$(set_prompt_symbol) "

# Git signed key
export GPG_TTY=$(tty)

ZSH_DISABLE_COMPFIX=true

# TODO
# env
# export GOPATH="/home/njfamirm/go"
# export GOROOT="/usr/lib/go"
# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
