#!/usr/bin/env bash
set -euo pipefail

sudo snap install nvim --classic
sudo apt update
sudo apt install -y ripgrep fd-find curl build-essential cmake clang clangd clang-format clang-tidy bear

mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null 2>&1 && [ ! -e "$HOME/.local/bin/fd" ]; then
  ln -s "$(which fdfind)" "$HOME/.local/bin/fd"
fi

uv tool install pyrefly
uv tool install ruff
uv tool install jupytext

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
LAZYGIT_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
curl -Lo "$tmpdir/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
tar xf "$tmpdir/lazygit.tar.gz" -C "$tmpdir" lazygit
sudo install "$tmpdir/lazygit" -D -t /usr/local/bin/
