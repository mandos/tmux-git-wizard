get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value
  option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

set_tmux_option() {
  local option="$1"
  local default_value="$2"
  local value
  value=$(get_tmux_option "$option" "$default_value")

  tmux set-option -gq "$option" "$value"
  echo "$value"
}

_git_wizard_choose_branches() {
  # git branch -vv | fzf --preview 'git branch -vv | grep {}'
  local worktrees
  local branches
  worktrees=$(git worktree list)
  branches=$(git branch -vv)
  # echo "$worktrees" "" "$branches" | fzf
}
