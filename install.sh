#!/usr/bin/env bash

echo "▶ Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
else
  echo "    Oh My Zsh already installed."
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew analytics off
else
  echo "    Homebrew already installed."
fi

# Update Homebrew recipes
brew update

# Install dependencies with bundle (See Brewfile)
brew bundle --file ./Brewfile

# Install iTerm2 settings
echo "▶ Applying iTerm2 settings..."
~/dotfiles/iterm/install.sh

# Symlink files from dotfile repo to home directory
echo "▶ Symlinking dotfiles to home directory..."
DOTFILES_DIR="$HOME/dotfiles"
ln -sf "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc

# Set macOS preferences - we will run this last because this will reload the shell
echo "▶ Applying macOS settings..."
source ./.macos
