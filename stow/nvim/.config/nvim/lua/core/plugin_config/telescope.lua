local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tt', builtin.git_files, {})
vim.keymap.set('n', '<leader>te', builtin.find_files, {})
vim.keymap.set('n', '<leader>tl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
vim.keymap.set('n', '<leader>th', builtin.help_tags, {})
--vim.keymap.set('n', '<leader>tr', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>tr', builtin.treesitter, {}) -- 
vim.keymap.set('n', '<leader>tR', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
vim.keymap.set('n', '<leader>ss', builtin.spell_suggest, {})
vim.keymap.set('n', '<C-f><C-r>', builtin.lsp_references, {})
vim.keymap.set('n', '<C-f><C-f>', builtin.lsp_definitions, {})
vim.keymap.set('n', '<C-f><C-i>', builtin.lsp_implementations, {})
vim.keymap.set('n', '<C-f><C-t>', builtin.lsp_type_definitions, {})
vim.keymap.set('n', '<C-f><C-c>', builtin.lsp_outgoing_calls, {})
vim.keymap.set('n', '<C-f><C-C>', builtin.lsp_incoming_calls, {})
vim.keymap.set({'n', 'v'}, 'K', builtin.grep_string, {})

local actions = require "telescope.actions"
require("telescope").setup {
  pickers = {
    buffers = {
      mappings = {
        n = {
          ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
        }
      }
    },
    live_grep = {
      initial_mode = "insert"
    }
  },
  defaults = {
    initial_mode = "insert",
    layout_config = {
      horizontal = {
        anchor = "S",
        height = 0.3,
        width = 0.95,
      },
    },
  },
}

require('telescope').load_extension('fzf')
