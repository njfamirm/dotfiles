eval $(thefuck --alias)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# https://github.com/rupa/z
. ~/.oh-my-zsh/alwatrZsh/script/z.sh
set $_Z_MAX_SCORE 1000

if [[ -n "$SSH_CLIENT" && -n "$TMUX" ]] ; then
    tmux unbind M-q
    tmux set -g prefix M-w
    tmux bind M-w send-prefix
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$ZSH/alwatrZsh

# tmux plugin Config
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_DEFAULT_SESSION_NAME="alwatr-zsh"
ZSH_TMUX_PREFIX_ON_SSH="M-w"
SSH_CONNECTION=false
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # ssh-agent
  tmux
  golang
  zsh-z
)

source $ZSH/oh-my-zsh.sh

DOTFILES=~/.dotfiles
for config_file ("$DOTFILES"/scripts/**/*.sh); do
  source "$config_file"
done
unset config_file

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

PROMPT="%F{blue}%n@%M %F{white}at %F{reset_color}%F{yellow}%~%F{reset_color} "$'$(set_git_prompt)'$'\n'"%F{yellow}$%F{reset_color} " # move to theme

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

