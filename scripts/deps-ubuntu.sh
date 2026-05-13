#!/usr/bin/env bash
set -euo pipefail

sudo snap install nvim --classic
sudo apt update
sudo apt install -y ripgrep fd-find

mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null 2>&1 && [ ! -e "$HOME/.local/bin/fd" ]; then
  ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
fi

uv tool install pyrefly
uv tool install ruff
uv tool install jupytext
