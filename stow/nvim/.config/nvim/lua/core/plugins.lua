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

  {
    "tinted-theming/tinted-nvim",
    version = "1.*",
    priority = 1000,
    lazy = false,
  },
  "neovim/nvim-lspconfig",
  { "nvim-treesitter/nvim-treesitter", branch = "master" },


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
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },


  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
  },


  'nvim-tree/nvim-web-devicons',
  {
    'rebelot/terminal.nvim',
    config = function()
      require("terminal").setup({})


      local opts = {}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      vim.keymap.set('t', "<C-b>", [[<C-\><C-n>split<CR>]], { noremap = false })
      vim.keymap.set('t', "<C-v>", [[<C-\><C-n>vsplit<CR>]], { noremap = false })
      vim.keymap.set('t', "<C-g>", [[<C-\><C-n><C-w>q]], { noremap = false })

      vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
        callback = function(args)
          if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
            vim.cmd("startinsert")
          end
        end,
      })
    end
  },






  'nvim-tree/nvim-tree.lua',
  'lewis6991/gitsigns.nvim',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-buffer',
  'preservim/nerdcommenter',

  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  'mfussenegger/nvim-dap',
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  require("core.plugin_config.jdtls"),

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
    }
  },
}

vim.cmd([[au BufRead,BufNewFile *.jq setfiletype jq]])

require("lazy").setup(plugins, {
  install = { missing = vim.env.DOTFILES_OFFLINE ~= '1' },
  checker = { enabled = false },
  change_detection = { notify = false },
})
