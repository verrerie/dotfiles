#!/usr/bin/env bash
# Symlinks this repo's configs into place. Run on macOS/Linux.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_config() {
	local name="$1" target="$2"
	# Already pointing at this repo: leave it alone. Without this, re-running
	# the script renames a good symlink to .bak and clobbers the backup of the
	# real config it replaced the first time.
	if [ -L "$target" ] && [ "$(readlink "$target")" = "$DOTFILES_DIR/$name" ]; then
		echo "Already linked: $target"
		return
	fi
	if [ -e "$target" ] || [ -L "$target" ]; then
		echo "Backing up existing $target to $target.bak"
		mv "$target" "$target.bak"
	fi
	ln -s "$DOTFILES_DIR/$name" "$target"
	echo "Linked $target -> $DOTFILES_DIR/$name"
}

mkdir -p "$HOME/.config"
link_config "nvim" "$HOME/.config/nvim"
link_config "yazi" "$HOME/.config/yazi"

# No Windows counterpart in install.ps1 - this one is zsh only.
link_config "zsh/zshenv" "$HOME/.zshenv"
