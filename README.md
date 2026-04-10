# nvim-config

## Setup

1. Backup existing config (optional):

```bash
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)
```

2. Clone this repo:

```bash
git clone <repo-url> ~/.config/nvim
```

3. Install dependencies:

```bash
~/.config/nvim/scripts/deps-macos.sh
```

```bash
~/.config/nvim/scripts/deps-ubuntu.sh
```

4. Start Neovim:

```bash
nvim
```

5. Install plugins (inside Neovim):

```bash
:Lazy sync
```

6. Restart Neovim.
