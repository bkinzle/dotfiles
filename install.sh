#!/usr/bin/env bash

echo "▶ Setting up your Mac..."

# Ask for the administrator password upfront
sudo -v

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
echo
echo "▶ Installing Homebrew packages..."
brew bundle --file ./Brewfile

# Install iTerm2 settings
echo
echo "▶ Applying iTerm2 settings..."
~/dotfiles/iterm/install.sh

# Symlink files from dotfile repo to their well-known/default locations
echo
echo "▶ Symlinking dotfiles to their well-known/default locations..."
DOTFILES_DIR="$HOME/dotfiles"
ln -sf "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/aliases.zsh" ~/.oh-my-zsh/custom/aliases.zsh
ln -sf "$DOTFILES_DIR/.hushlogin" ~/.hushlogin
ln -sf "$DOTFILES_DIR/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json

# Clone oh-my-zsh plugins if they don't exist
echo
echo "▶ Cloning oh-my-zsh plugins if they don't exist..."
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search" ]; then
   git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
fi
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
   git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Set macOS preferences - we will run this last because this will reload the shell
echo
echo "▶ Applying macOS settings..."
source ./.macos
