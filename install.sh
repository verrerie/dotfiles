#!/usr/bin/env bash
# Symlinks this repo's nvim config into place. Run on macOS/Linux.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$HOME/.config/nvim"

mkdir -p "$HOME/.config"

if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
	echo "Backing up existing $TARGET to $TARGET.bak"
	mv "$TARGET" "$TARGET.bak"
fi

ln -s "$DOTFILES_DIR/nvim" "$TARGET"
echo "Linked $TARGET -> $DOTFILES_DIR/nvim"
