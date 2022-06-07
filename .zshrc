export ZSH="$HOME/.oh-my-zsh"

if [[ -n "$SSH_CLIENT" && -n "$TMUX" ]] ; then
    tmux unbind M-q
    tmux set -g prefix M-w
    tmux bind M-w send-prefix
fi

zstyle ':omz:update' mode reminder

# tmux plugin Config
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_DEFAULT_SESSION_NAME="alwatr-zsh"
ZSH_TMUX_PREFIX_ON_SSH="M-w"

plugins=(
  # ssh-agent
  # tmux
)

source $ZSH/oh-my-zsh.sh

DOTFILES=~/.dotfiles
for config_file ("$DOTFILES"/scripts/**/*.*sh); do
  source "$config_file"
done
unset config_file

# zsh-z
set $_Z_MAX_SCORE 1000
autoload -U compinit && compinit

PROMPT="%F{yellow}%n %F{white}at %F{reset_color}%F{blue}%~%F{reset_color} "$'$(set_git_prompt)'$'\n'"%F{yellow}$%F{reset_color} "
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
