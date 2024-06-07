local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- color schemes
  --'RRethy/base16-nvim',
  { 'chriskempson/base16-vim',
    config = function()
      vim.cmd [[ colorscheme base16-pop ]]

      local old_hl = vim.api.nvim_get_hl_by_name('Comment', true)
      local new_hl = vim.tbl_extend('force', old_hl, {italic = true})
      vim.api.nvim_set_hl(0, 'Comment', new_hl)

    end
  },

  -- Autocomplete and parsing stuff
  "neovim/nvim-lspconfig",
  "nvim-treesitter/nvim-treesitter",

  -- Fuzzy find for many types of things<LeftMouse>
  --{ "junegunn/fzf", dir = "~/.fzf", run = "./install --all" },
  --"junegunn/fzf.vim",

  -- Script for the vim part of rigging movement keys to be unified between
  -- tmux and vim
  -- I use this to setup one set of key bindings that can move focus between
  -- vim splits and tmux splits doing sensible things.
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  {
    "vim-scripts/a.vim",
    cmd = {
      "A",
    },
    keys = {
      { "^-", ":A<CR>" },
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  --{'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = {
      'nvim-lua/plenary.nvim', 
      'nvim-telescope/telescope-fzf-native.nvim',
    },
  },

  



  'nvim-tree/nvim-tree.lua',
  'lewis6991/gitsigns.nvim',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'preservim/nerdcommenter',

  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
}

require("lazy").setup(plugins, opts)
