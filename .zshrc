export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode reminder

# tmux plugin Config
ZSH_TMUX_AUTOSTART=true

source $ZSH/oh-my-zsh.sh

DOTFILES=~/.dotfiles
for config_file ("$DOTFILES"/scripts/**/*.*sh); do
  source "$config_file"
done
unset config_file

# zsh-z
set $_Z_MAX_SCORE 1000
autoload -U compinit && compinit

set_prompt_symbol() {
  if [ $EUID -ne "0" ]; then
    echo "$"
  else
    echo "#"
  fi
}

PROMPT="%F{green}%n %F{white}at %F{reset_color}%F{blue}%~%F{reset_color} "$'$(set_git_prompt)'$'\n'"%F{yellow}$(set_prompt_symbol)%F{reset_color} "
BIG_PROMPT=$PROMPT

SMALL_PROMPT="%F{blue}"'${${(s:/:)PWD}[-2]}/${PWD:t}'"%F{reset_color}"$'\n'"%F{yellow}$ %F{reset_color}"

# change prompt size
resize() {
  if [ $PROMPT != $SMALL_PROMPT ]; then
  	PROMPT=$SMALL_PROMPT
  else
    PROMPT=$BIG_PROMPT
  fi
}

# Git signed key
export GPG_TTY=$(tty)

eval $(thefuck --alias)
ZSH_DISABLE_COMPFIX=true
