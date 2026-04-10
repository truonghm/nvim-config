#!/usr/bin/env bash
set -euo pipefail

brew install neovim ripgrep fd

uv tool install pyrefly
uv tool install ruff
uv tool install jupytext
