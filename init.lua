-- vim: ts=2 sts=2 sw=2 et

-- External tools required
-- git
-- ripgrep: https://github.com/BurntSushi/ripgrep
-- sharkdp/fd

-- Disable netrw for neo-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.g.loaded_python3_provider = 0

local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.mouse = "a"

opt.autowrite = true
opt.autoread = true
opt.confirm = true
opt.inccommand = "nosplit"
opt.laststatus = 0
opt.list = true
opt.updatetime = 1000

opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.number = true
opt.relativenumber = true

opt.splitbelow = true
opt.splitright = true
opt.equalalways = false

opt.scrolloff = 4
opt.sidescrolloff = 8
opt.winminwidth = 5

opt.expandtab = true
opt.shiftwidth = 4
opt.shiftround = true
opt.tabstop = 4

opt.showmode = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.hidden = true

opt.undofile = true
opt.undolevels = 10000

opt.secure = true
opt.exrc = true

-- set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>')

vim.keymap.set('t', '<Esc>', "<C-\\><C-n>")
vim.keymap.set('t', '<C-w>', "<C-\\><C-n><C-w>")

-- minimize terminal split
vim.keymap.set('n', '<C-g>', "3<C-w>_")

-- plugins

require("lazy").setup({
  -- theme
 -- { "catppuccin/nvim", lazy = true, name = "catppuccin", priority=1000 },
  { "sainnhe/everforest", lazy = false, name = "everforest", priority=1000 },

  -- devicons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- snippets
  { "L3MON4D3/LuaSnip", event = "VeryLazy",
    config = function()
      require("luasnip.loaders.from_lua").load({paths = "./snippets"})
    end
  },

  -- language server protocol
  { "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.lsp.config("pyrefly", {
        capabilities = capabilities,
        settings = {
          python = {
            pyrefly = {
              displayTypeErrors = "force-on",
            },
          },
        },
      })
      vim.lsp.enable("pyrefly")
    end
  },

  -- autocompletion
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip"
    },
    config = function()
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        completion = {
          autocomplete = false
        },
        mapping = cmp.mapping.preset.insert ({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<s-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<c-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select=true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }
      })
    end
  },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter", version = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "javascript" },
        auto_install = false,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-n>",
            node_incremental = "<C-n>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-m>",
          }
        }
      })
    end
  },

  -- jupyter notebook (.ipynb) editing via jupytext
  { "goerz/jupytext.nvim", version = "0.2.0", lazy = false,
    opts = {
      format = "py:percent",
      update = true,
      autosync = true,
    }
  },

  -- sidebar explorer
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>", desc = "Toggle Explorer" },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        hijack_netrw_behavior = "open_default",
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
      window = {
        position = "left",
        width = 32,
        auto_expand_width = false,
        mappings = {
          ["e"] = "none",
        },
      },
    },
  },

  -- fuzzy find
  { "nvim-telescope/telescope.nvim", cmd = "Telescope", version = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sf", "<cmd>Telescope git_files<cr>", desc = "Find Files (root dir)" },
      { "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Search Project" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search Document Symbols" },
      { "<leader>sw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Search Workspace Symbols" },
    },
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case"
        }
      } 
    }
  },

  { "nvim-telescope/telescope-fzf-native.nvim", 
    build = "make",
    config = function()
      require('telescope').load_extension('fzf')
    end
  },

  -- linting + formatting
  { "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    }
  },

  { "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "ruff" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end
  },

  -- terminal
  { "akinsho/toggleterm.nvim", event = "VeryLazy", version = "*",
    opts = {
      size = 10,
      open_mapping = "<leader>tt",
    }
  },

  -- status line
  { "nvim-lualine/lualine.nvim", event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      }
    },
  },

  -- bufferline
  { "akinsho/bufferline.nvim", version = "v4.*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc="Toggle Buffer Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", desc="Close Unpinned Buffers" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        numbers = "buffer_id",
        always_show_bufferline = false
      }
    }
  },

  -- auto pairing
  { "echasnovski/mini.pairs", event="VeryLazy",
    config = function(_, opts)
      require('mini.pairs').setup(opts)
    end
  },

  -- surround text object
  { "echasnovski/mini.surround",
    config = function(_, opts)
      require('mini.surround').setup(opts)
    end
  },

  -- show indent guides on blank lines
  { "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
    }
  },
})

-- set colour scheme
vim.g.everforest_enable_italic = true
vim.cmd.colorscheme "everforest"

-- up / down with line wrap
vim.keymap.set('n', '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

local external_changes_group = vim.api.nvim_create_augroup('ExternalFileChanges', { clear = true })
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = external_changes_group,
  callback = function()
    if vim.fn.mode() ~= 'c' then
      vim.cmd('silent! checktime')
    end
  end,
})

-- highlight yanked text
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- lsp keybindings
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {desc = 'Rename Symbol'})
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {desc = 'Goto Definition'})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = 'Code Action'})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = 'Hover Documentation'})
vim.keymap.set('n', '<leader>ff', function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, {desc = 'Format Code'})
vim.diagnostic.config({
  virtual_lines = { current_line=true },  -- Enables inline error/warning text
})
