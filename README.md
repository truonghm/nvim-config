# nvim-config

## Setup

1. Backup existing config (optional):

```bash
mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d-%H%M%S)
```

2. Clone this repo:

```bash
git clone https://github.com/truonghm/nvim-config ~/.config/nvim
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

## C/C++

This config uses the LLVM tooling stack for C and C++:

- `clangd` for LSP features
- `clang-format` for formatting
- `clang-tidy` for linting/static analysis

Install the tools with your system package manager. On Arch Linux, `clang` provides `clangd`, `clang-format`, and `clang-tidy`:

```bash
sudo pacman -S clang bear
```

`clangd` and `clang-tidy` work best when the project has a `compile_commands.json` file. This file tells the tools the compiler flags, include paths, and defines used by the build.

For CMake projects, configure the project with compile command export enabled:

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -sf build/compile_commands.json compile_commands.json
```

For Make projects, generate it with `bear`:

```bash
bear -- make
```

Run the command from the project root so `compile_commands.json` is created where Neovim, `clangd`, and `clang-tidy` can find it.
