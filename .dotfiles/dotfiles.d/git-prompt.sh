#!/usr/bin/zsh

# git prompt generator
# "#" means that staged
# "+" means that unstaged
# "?" means that untracked

get_branch() {
  echo $(git branch --show-current 2>/dev/null)
}

get_staged_files_count() {
  echo $(git diff --cached --numstat 2>/dev/null | wc -l)
}

get_unstaged_files_count() {
 echo $(git diff --name-only 2>/dev/null | wc -l)
}

get_untracked_files_count() {
  echo $(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
}

set_git_prompt() {
  branch=$(get_branch)
  staged=$(get_staged_files_count)
  unstaged=$(get_unstaged_files_count)
  untracked=$(get_untracked_files_count)
  if [ ! -z "$branch" ];then
    git_prompt="[%F{#2280bf}$branch%F{reset_color}"
  else
    return 0
  fi
  [ ! "$staged" -eq "0" ] && git_prompt="$git_prompt,%F{#55a630}#$staged%F{reset_color}";
  [ ! "$unstaged" -eq "0" ] && git_prompt="$git_prompt,%F{#f5d7bd}+$unstaged%F{reset_color}";
  [ ! "$untracked" -eq "0" ] && git_prompt="$git_prompt,%F{#f94144}?$untracked%F{reset_color}";
  git_prompt="$git_prompt]"
  echo $git_prompt
}

