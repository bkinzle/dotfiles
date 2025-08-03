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
ln -sf "$DOTFILES_DIR/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/aliases.zsh" ~/.oh-my-zsh/custom/aliases.zsh
ln -sf "$DOTFILES_DIR/.hushlogin" ~/.hushlogin
mkdir -p ~/.config/mise
ln -sf "$DOTFILES_DIR/.config/mise/config.toml" ~/.config/mise/config.toml
ln -sf "$DOTFILES_DIR/vscode/settings.json" ~/Library/Application\ Support/Code/User/settings.json
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig

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

# Install mise managed tools
echo
echo "▶ Installing mise managed tools..."
source ~/.zprofile && mise upgrade --yes

# Create cron jobs
echo
echo "▶ Creating cron jobs..."
~/dotfiles/cron/brew_update_upgrade_cleanup_cron.sh
~/dotfiles/cron/mise_global_tool_upgrade_cron.sh

# Set macOS preferences - we will run this last because this will reload the shell
echo
echo "▶ Applying macOS settings..."
source ./.macos
