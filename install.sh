#!/usr/bin/env bash
# Symlinks this repo's configs into place. Run on macOS/Linux.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_config() {
	local name="$1" target="$2"
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
