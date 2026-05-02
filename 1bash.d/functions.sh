#!/bin/bash

# List all files, long format, colorized, permissions in octal
function la {
 	lsa -l  "$@" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# git commit browser. needs fzf
function glog {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}

function random() {
	openssl rand -hex 32
}

# clean remote removed git branch include not pushed branch
function cb() {
  for branch in $(git branch --no-color --merged | grep -Ev "\*|next"); do
    read -p "Are you sure you want to delete $branch? (y/N) " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
      git branch -d "$branch"
    fi
  done
}

function localIp() {
  ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
}

function publicIp() {
   curl -s ipinfo.io/json
}

# ==============================================================================
# Load all rarely-used utility scripts on demand
# ==============================================================================
load_utils() {
  echo "🚀 Loading utilities from utils.sh..."
  if [ -r "$ONE_BASH/utils.sh" ]; then
    source "$ONE_BASH/utils.sh"
    echo "🎉 All utilities are now available in this session!"
  else
    echo "❌ utils.sh not found!"
  fi
}
