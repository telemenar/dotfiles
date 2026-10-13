
vim.keymap.set('i', 'jk', '<Esc>', { desc = "Use 'kj' keys in quick succession for ESC" })

-- Paste without overwriting register
--vim.keymap.set("v", "p", '"_dp', { desc = "Paste without overwriting register"})

-- Copy text to " register
vim.keymap.set({"n", "v"}, "<leader>y", "\"+y", { desc = "Yank into \" register" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank into \" register" })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete into \" register" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete into \" register" })

-- Keep window centered when going up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")


vim.keymap.set("n", "<leader>T", function()
   vim.cmd("cd %:p:h")
   vim.cmd("belowright split | terminal")
   vim.cmd("startinsert")
end, { desc = "Open terminal in folder of current file"})

-- Find and replace visual selection using CTRL-r
vim.keymap.set("v", "<C-r>", "\"hy:%s/<C-r>h//gc<left><left><left>")

vim.keymap.set("n", "<S-space>", "<C-b>")
vim.keymap.set("n", "<space>", "<C-f>")
vim.keymap.set({"n"}, "<C-b>", ":split<CR>", {noremap = false})
vim.keymap.set({"n"}, "<C-v>", ":vsplit<CR>", {noremap = false})
vim.keymap.set({"n"}, "<C-g>", "<C-w>q", {noremap = false})
