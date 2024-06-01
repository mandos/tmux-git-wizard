#!/usr/bin/env bash
set -x

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/src/helpers.sh"

set_git_wizard_options() {
  local height width shortcut
  shortcut=$(set_tmux_option "@git-wizard-shortcut" "g")
  height=$(set_tmux_option "@git-wizard-height" 40)
  width=$(set_tmux_option "@git-wizard-width" 80)

  tmux bind "$shortcut" display-popup -w "$width"% -h "$height"% -E "$CURRENT_DIR/bin/tmux_git_wizard.sh"
}

set_git_wizard_options
