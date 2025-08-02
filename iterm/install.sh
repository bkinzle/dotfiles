#!/usr/bin/env bash
set -e

COLORSCHEME="$HOME/dotfiles/iterm/colors/GitHub-Dark-High-Contrast.itermcolors"
MARKER="$HOME/dotfiles/iterm/.color-scheme-imported"


# Import the color scheme into iTerm2
if [ ! -f "$MARKER" ]; then
  echo "    Importing color scheme into iTerm2..."
  open "$COLORSCHEME"
  touch "$MARKER"
else
  echo "    Marker file .color-scheme-imported already exists, skipping iTerm2 color scheme import."
fi

echo
echo "    ⚠️ Be sure to set iTerm2 to load preferences from custom folder if you haven't already:"
echo "        Settings → Settings Tab → External settings:  Load preferences from a custom folder or URL → $HOME/dotfiles/iterm/settings"

