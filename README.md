# My Dotfiles

My personal dotfiles for bash.

## Install and Upgrade

```bash
export DOTFILES="$HOME/dotfiles"
bash <(curl -s "https://raw.githubusercontent.com/njfamirm/dotfiles/main/setup.sh")
source ~/.bash_profile
```

## Machine-specific settings

Machine-specific stuff (GPG signing key, extra `PATH`s, credentials) lives in
local files that are **not tracked** by this repo:

- `~/.gitconfig.local` — included from `gitconfig`
- `~/.bash_profile.local` — sourced from `bash_profile.sh`

`setup.sh` creates them from `*.local.example` templates on a new machine.

## Credit
- [1bash](https://github.com/alimd/1bash)
