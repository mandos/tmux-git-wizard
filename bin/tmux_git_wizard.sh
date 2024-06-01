#!/usr/bin/env bash
# set -x

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# source "$CURRENT_DIR/../src/helpers.sh"
#
# _git_wizard_choose_branches

branch=$(git branch --list --format='%(refname)' | sed -r 's|^refs/heads/||' | fzf --preview 'git branch -vv | grep {}')

if [ -n "$branch" ]; then

  tmux_windows=$(tmux list-windows -F "#{window_name}" -f "#{m:$branch,#{window_name}}")
  if [ -z "$tmux_windows" ]; then
    tmux_windows=$branch
    worktree=$(git worktree list | grep -F "$branch")
    if [ -n "$worktree" ]; then
      dir=$(echo "$worktree" | awk '{print $1}')
      tmux new-window -n "$tmux_windows" -c "$dir"
    else
      git worktree add "./.worktree/$branch" "$branch"
      tmux new-window -n "$tmux_windows" -c "./.worktree/$branch"
    fi
  fi

  tmux select-window -t "$tmux_windows" 2>/dev/null

fi
