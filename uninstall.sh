#!/bin/bash

set -e

echo "Uninstalling dotfiles..."

DOTFILES_DIR="$HOME/dotfiles"
OLD_DIR="$HOME/.old-dotfiles"

# helper: remove symlink if it exists
remove_link() {
  if [ -L "$1" ]; then
    rm "$1"
    echo "Removed symlink: $1"
  fi
}

# helper: restore backup if it exists
restore_file() {
  if [ -e "$OLD_DIR/$2" ]; then
    mv "$OLD_DIR/$2" "$1"
    echo "Restored: $1"
  fi
}

# remove symlinks
remove_link "$HOME/.zshrc"
remove_link "$HOME/.p10k.zsh"
remove_link "$HOME/.gitconfig"
remove_link "$HOME/.oh-my-zsh/custom/aliases.zsh"
remove_link "$HOME/.oh-my-zsh/custom/functions.zsh"

# restore backups
restore_file "$HOME/.zshrc" ".zshrc"
restore_file "$HOME/.p10k.zsh" ".p10k.zsh"
restore_file "$HOME/.gitconfig" ".gitconfig"
restore_file "$HOME/.oh-my-zsh/custom/aliases.zsh" ".oh-my-zsh/custom/aliases.zsh"
restore_file "$HOME/.oh-my-zsh/custom/functions.zsh" ".oh-my-zsh/custom/functions.zsh"

# optional: remove dotfiles repo
read -p "Remove ~/dotfiles directory? (y/N): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  rm -rf "$DOTFILES_DIR"
  echo "Removed ~/dotfiles"
fi

# remove empty backup dir
rmdir --ignore-fail-on-non-empty "$OLD_DIR"

echo "Uninstall complete. Restart your shell."
