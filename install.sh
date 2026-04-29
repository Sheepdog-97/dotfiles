#!/bin/bash

set -e

echo "Installing dotfiles..."

DOTFILES_DIR="$HOME/dotfiles"
OLD_DIR="$HOME/.old-dotfiles"

# clone repo if not exists
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone https://github.com/sheepdog-97/dotfiles.git "$DOTFILES_DIR"
else
  echo "Dotfiles repo already exists, skipping clone."
fi

# create backup dirs
mkdir -p "$OLD_DIR/.oh-my-zsh/custom"

# helper function to move if exists
backup_file() {
  if [ -e "$1" ]; then
    mv "$1" "$OLD_DIR/$2"
  fi
}

# backup files
backup_file "$HOME/.zshrc" ".zshrc"
backup_file "$HOME/.p10k.zsh" ".p10k.zsh"
backup_file "$HOME/.gitconfig" ".gitconfig"
backup_file "$HOME/.gitconfig.private" ".gitconfig.private"
backup_file "$HOME/.oh-my-zsh/custom/aliases.zsh" ".oh-my-zsh/custom/aliases.zsh"
backup_file "$HOME/.oh-my-zsh/custom/functions.zsh" ".oh-my-zsh/custom/functions.zsh"

# create symlinks
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.gitconfig.private" "$HOME/.gitconfig.private"
ln -sf "$DOTFILES_DIR/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"
ln -sf "$DOTFILES_DIR/functions.zsh" "$HOME/.oh-my-zsh/custom/functions.zsh"

echo "Done. Restart your shell."