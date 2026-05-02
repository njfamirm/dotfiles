#!/bin/bash

apt_update() {
  echo "Updating package lists..."
  sudo apt update

  echo "Upgrading all installed packages..."
  sudo apt upgrade -y

  echo "Cleaning up old versions of installed packages..."
  sudo apt autoremove -y
  sudo apt clean

  echo "APT maintenance completed."
}

apt_setup_base() {
  PACKAGES=('tmux' 'tree' 'vim' 'git' 'curl' 'wget')
  echo "Installing packages with apt"
  sudo apt update
  sudo apt upgrade -y
  # check if package already installed, if not, install it
  for i in "${PACKAGES[@]}"; do
    if dpkg -l | grep -q "^ii  $i "; then
      echo "$i already installed"
    else
      echo "Installing $i"
      sudo apt install -y $i
    fi
  done
  sudo apt autoremove -y
  sudo apt clean
}
#!/bin/bash

[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

export HOMEBREW_NO_ENV_HINTS=1

# Function to update, upgrade, and clean up Homebrew
brew_update() {
  brew update-reset

  echo "Updating Homebrew..."
  brew update

  echo "Upgrading all installed packages..."
  brew upgrade
  brew upgrade --cask

  echo "Cleaning up old versions of installed packages..."
  brew cleanup --prune=all --verbose --scrub
  rm -rf "$(brew --cache)"
  brew autoremove

  brew doctor

  echo "Homebrew maintenance completed."
}

brew_setup_base() {
  PACKAGES=('tmux' 'tree' 'vim' 'git' 'curl' 'wget' 'fzf' 'v2ray' 'zoxide' 'gh')
  echo "Install packages with brew"
  brew update
  brew upgrade
  # check if package already installed, if not, install it
  for i in "${PACKAGES[@]}"; do
    if brew ls --versions $i >/dev/null; then
      echo "$i already installed"
    else
      echo "Installing $i"
      brew install $i
    fi
  done
  brew cleanup --prune=all
  brew autoremove
}
# Function to send a notification using the Terminal Notifier
function ncWatch() {
  local local_ip=$(localIp)
	echo "nc watch on ${local_ip}:"
	nc -l 2080 | while read message; do
		echo "$message" | pbcopy
		echo "$message"
		echo "Copied!"
	done
}

function echoNc() {
	local ip="$1"
	local message="$2"
	echo "$message" | nc "$ip" 2080
	echo "Sent!"
}

# get gzipped size
function gz {
	echo "orig size    (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# whois a domain or a URL
function whois {
	local domain=$(echo "$1" | awk -F/ '{print $3}') # get domain from URL
	if [ -z $domain ] ; then
		domain=$1
	fi
	echo "Getting whois record for: $domain …"

	# avoid recursion
					# this is the best whois server
													# strip extra fluff
	/usr/bin/whois -h whois.internic.net $domain | sed '/NOTICE:/q'
}

# Extract archives - use: extract <file>
# Based on http://dotfiles.org/~pseup/.bashrc
function extract {
	if [ -f "$1" ] ; then
		local filename=$(basename "$1")
		local foldername="${filename%%.*}"
		local fullpath=`perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1"`
		local didfolderexist=false
		if [ -d "$foldername" ]; then
			didfolderexist=true
			read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
			echo
			if [[ $REPLY =~ ^[Nn]$ ]]; then
				return
			fi
		fi
		mkdir -p "$foldername" && cd "$foldername"
		case $1 in
			*.tar.bz2) tar xjf "$fullpath" ;;
			*.tar.gz) tar xzf "$fullpath" ;;
			*.tar.xz) tar Jxvf "$fullpath" ;;
			*.tar.Z) tar xzf "$fullpath" ;;
			*.tar) tar xf "$fullpath" ;;
			*.taz) tar xzf "$fullpath" ;;
			*.tb2) tar xjf "$fullpath" ;;
			*.tbz) tar xjf "$fullpath" ;;
			*.tbz2) tar xjf "$fullpath" ;;
			*.tgz) tar xzf "$fullpath" ;;
			*.txz) tar Jxvf "$fullpath" ;;
			*.zip) unzip "$fullpath" ;;
			*) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# animated gifs from any video
# from alex sexton   gist.github.com/SlexAxton/4989674
function gifify {
  if [[ -n "$1" ]]; then
	if [[ $2 == '--good' ]]; then
	  ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
	  time convert -verbose +dither -layers Optimize -resize 900x900\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
	  rm out-static*.png
	else
	  ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
	fi
  else
	echo "proper usage: gifify <input_movie.mov>. You DO need to include extension."
  fi
}

# turn that video into webm.
# brew reinstall ffmpeg --with-libvpx
function webmify {
	ffmpeg -i $1 -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y $2 $1.webm
}

# ffmpeg

function ffm {
  ffmpeg "${@:1:$#-1}" -map_metadata 0 -movflags +faststart -benchmark "${!#}"
}

function convert2m4a {
  input="$1"; shift;

  echo "Convert (-c:a aac -b:a 64k -ar 22050)"
  ffm -i "$input" -vn -c:a aac -b:a 64k -ar 22050 "$@" "${input}-low-quality.m4a"

  echo "Convert (-c:a aac -b:a 128k -ar 44100)"
  ffm -i "$input" -vn -c:a aac -b:a 128k -ar 44100 "$@" "${input}-medium-quality.m4a"

  echo "Convert (-c:a aac -b:a 192k -ar 48000)"
  ffm -i "$input" -vn -c:a aac -b:a 192k -ar 48000 "$@" "${input}-high-quality.m4a"
}

function convert2mp4 {
	input="$1"; shift;
  ffm -i "$input" -c:v libx264 -c:a aac -q:a 0.5 $@ "${input}.mp4"
}
# Generate a new GPG key
generate_gpg_key() {
    gpg --full-generate-key
}

# Delete a GPG key by key ID
delete_gpg_key() {
    local key_id=$1
    gpg --delete-secret-keys $key_id
    gpg --delete-keys $key_id
}

# Export a public key to a file
export_gpg_public_key() {
    local key_id=$1
    gpg --export -a $key_id
}

# Export a private key to a file
export_gpg_private_key() {
    local key_id=$1
    gpg --export-secret-keys -a $key_id
}

# List all GPG keys
list_gpg_keys() {
    gpg --list-keys
}

# List all secret GPG keys
list_secret_gpg_keys() {
    gpg --list-secret-keys
}

# Import a GPG key from a file
import_gpg_key() {
    local input_file=$1
    gpg --import $input_file
}
setup_mac() {
  printf "⚙️ Configure Desktop...\n"
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool true

  printf "⚙️ Configure Finder...\n"
  defaults write com.apple.finder "QuitMenuItem" -bool true                    # Allow quitting via ⌘ + Q; doing so will also hide desktop icons
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool true            # Show all filename extensions
  defaults write com.apple.finder "AppleShowAllFiles" -bool true               # Show hidden files by default
  defaults write com.apple.finder "ShowPathbar" -bool true                     # Show path bar
  defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"        # Use list view in all Finder windows by default
  defaults write com.apple.finder "_FXSortFoldersFirst" -bool true             # Keep folders on top when sorting by name
  defaults write com.apple.finder "FinderSpawnTab" -bool true                  # Open folders in tabs instead of new windows
  defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"        # Search the current folder
  defaults write com.apple.finder "FXRemoveOldTrashItems" -bool true           # Empty Trash after 30 days
  defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool false # Disable the warning when changing a file extension
  defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "2"          # Set sidebar icon size to small
  chflags nohidden ~/Library                                                   # Show the ~/Library folder

  printf "⚙️ Rebuild Launch Services...\n"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user # Rebuild Launch Services to remove duplicates in the "Open With" menu

  killall Finder

  printf "⚙️ Configure Dock...\n"
  defaults write com.apple.dock "show-recents" -bool true             # Don’t show recent applications in Dock
  defaults write com.apple.dock "orientation" -string "right"         # Set the Dock to the right
  defaults write com.apple.dock "tilesize" -int "36"                  # Set the icon size of Dock items to 36 pixels
  defaults write com.apple.dock "autohide-time-modifier" -float "0.5" # Speed up Mission Control animations
  defaults write com.apple.dock "autohide-delay" -float "2"           # Remove the auto-hiding Dock delay
  defaults write com.apple.dock "mineffect" -string "genie"           # Set the minimize effect to Genie

  killall Dock

  printf "⚙️ Configure Screenshots...\n"
  mkdir ~/Pictures/Screenshots
  defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture "disable-shadow" -bool false
  defaults write com.apple.screencapture "include-date" -bool false
  defaults write com.apple.screencapture "show-thumbnail" -bool true

  defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool false

  defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm\""

  killall SystemUIServer

  printf "⚙️ Configure Safari...\n"
  defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true"
  killall Safari

  defaults write NSGlobalDomain com.apple.mouse.scaling -float "1.5"
  defaults write com.apple.Terminal "FocusFollowsMouse" -bool true
  killall Terminal

  defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "2"

  defaults write com.apple.HIToolbox AppleFnUsageType -int "2"
  defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false

  defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

  defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled -bool "false"

  defaults write com.apple.dock "expose-group-apps" -bool "false"

  killall Dock

  # printf "⚙️ Configure energy saving...\n"
  # sudo pmset -a displaysleep 15
  # sudo pmset -c sleep 0
  # sudo pmset -a hibernatemode 0
}

remove_logs() {
  sudo rm -rf /var/log/*
  printf "Logs removed"
}

flush_dns_cache() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
  printf "DNS cache flushed"
}

enable_firewall() {
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  printf "Network firewall enabled"
}

optimize_power() {
  printf "Setting standard power settings (display sleep 5 min)...\n"

  sudo pmset -a displaysleep 5 # Sets the display sleep timer to 5 minutes for all power sources ('-a').
  sudo pmset -a disksleep 10 # Keeps the hard disk sleep timer at 10 minutes for all power sources.
  sudo pmset -a womp 1 # Keeps Wake on Magic Packet enabled for all power sources.
  sudo pmset -a networkoversleep 0 # Disables network interfaces during sleep for all power sources.

  printf "Power settings optimized"
}

clear_system_caches() {
  sudo rm -rf ~/Library/Caches/*
  sudo rm -rf /Library/Caches/*
  printf "System caches cleared"
}

clear_font_caches() {
  sudo atsutil databases -remove
  sudo atsutil server -shutdown
  sudo atsutil server -ping
  printf "Font caches cleared"
}

remove_ds_store_files() {
  find . -name '.DS_Store' -depth -exec rm -f {} \;
  printf "DS_Store files removed"
}

disable_analytics() {
  brew analytics off
}
#!/bin/bash

function install_vim_plug() {
  local plug_path="$HOME/.vim/autoload/plug.vim"
  local plug_url="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

  if [ ! -f "$plug_path" ]; then
    echo "Downloading vim-plug..."
    if curl -fLo "$plug_path" --create-dirs "$plug_url"; then
      echo "vim-plug installed successfully."
    else
      echo "Failed to download vim-plug."
      return 1
    fi
  else
    echo "vim-plug already exists."
  fi
}

function install_vim_plugins() {
  echo "Installing vim plugins..."
  vim -c "PlugInstall" -c "qa"
}

function setup_vim() {
  install_vim_plug
  install_vim_plugins
}
if command -v /opt/homebrew/bin/brew > /dev/null 2>&1; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
#!/bin/bash

setProxy() {
  echo "🌐 Set http proxy on '1081', \`unsetProxy\` for disable"
  export http_proxy=http://127.0.0.1:1081
  export https_proxy=http://127.0.0.1:1081
  export all_proxy=http://127.0.0.1:1081
  export socks_proxy=socks5://127.0.0.1:1082
  git config --global http.proxy http://127.0.0.1:1081
  git config --global https.proxy http://127.0.0.1:1081
}

unsetProxy() {
  echo "🌐 Unset proxy"
  unset http_proxy
  unset https_proxy
  unset all_proxy
  git config --global --unset http.proxy
  git config --global --unset https.proxy
}
# connect to out server directly
alias ssh_tunnel_direct='ssh -C -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -c aes128-ctr -MND 0.0.0.0:1080 srvo'

# connect to middle server
alias ssh_tunnel_multi_hub='ssh -J mci -C -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -c aes128-ctr -MND 0.0.0.0:1080 srvo'
alias ssh_tunnel_multi_hub='ssh -c aes128-ctr -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -MNL 0.0.0.0:1080:127.0.0.1:1080 mci'

# Combined function for one-step proxy setup
function tunnel() {
  close_tunnel
  echo "🔄 Setting up tunnel and proxy..."
  proxy
  setProxy
  ssh_tunnel_multi_hub
}

# Direct tunnel to final server (skip middle server)
function direct_tunnel() {
  close_tunnel
  echo "🔄 Setting up direct tunnel..."
  proxy
  setProxy
  ssh_tunnel_direct
}

# Close everything in one command
function close_tunnel() {
  stop_proxy
  unsetProxy
  echo "🔄 Checking for SSH tunnel processes..."
  tunnel_pids=$(pgrep -f "ssh.*MN[DL].*1080")
  if [ -n "$tunnel_pids" ]; then
    echo "🛑 Killing SSH tunnel processes: $tunnel_pids"
    kill $tunnel_pids
  else
    echo "⚠️ No SSH tunnel processes found"
  fi
  echo "✅ All proxy services stopped"
}
#!/bin/bash

function proxy() {
  local config_file="$ONE_BASH/proxy.json"

  if [ -f /tmp/v2ray_pid ]; then
    stop_proxy
  fi

  echo "🚀 Run $config_file v2ray config"
  v2ray run --config $config_file > /dev/null &
  echo $! > /tmp/v2ray_pid
}

function stop_proxy() {
  if [ -f /tmp/v2ray_pid ]; then
    kill $(cat /tmp/v2ray_pid)
    rm -rf /tmp/v2ray_pid
    echo "🛑 v2ray stopped"
  else
    echo "⚠️ No v2ray process found"
  fi
}
