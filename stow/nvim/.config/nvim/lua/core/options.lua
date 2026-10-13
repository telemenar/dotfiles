vim.opt.backspace = "indent,eol,start" -- make backspace a more flexible
vim.opt.cpoptions:append('m') -- On showmatch wait .5 then return to original loc
vim.opt.cpoptions:append('q') -- When joining lines leave cursor between lines

vim.opt.clipboard:append("unnamed") -- share windows clipboard
vim.opt.signcolumn="number"


vim.opt.whichwrap="b,s,h,l,<,>,~,[,]" -- everything wraps
 --                | | | | | | | | |
 --                | | | | | | | | +-- "]" Insert and Replace
 --                | | | | | | | +-- "[" Insert and Replace
 --                | | | | | | +-- "~" Normal
 --                | | | | | +-- <Right> Normal and Visual
 --                | | | | +-- <Left> Normal and Visual
 --                | | | +-- "l" Normal and Visual (not recommended)
 --                | | +-- "h" Normal and Visual (not recommended)
 --                | +-- <Space> Normal and Visual
 --                +-- <BS> Normal and Visual

vim.opt.wildmode = "list:longest" -- turn on wild mode huge list

-- show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.report = 0 -- report when any lines are changed

vim.opt.shortmess:append('a') -- abbrv a bunch of basic messages
vim.opt.shortmess:append('s') -- don't show continue searching at top

vim.opt.showmatch = true

vim.opt.scrolloff = 10 -- Keep 10 lines (top/bottom) for scope
vim.opt.sidescrolloff = 10  -- allow to scroll past side of buffer

-- use spaces for tabs and whatnot
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

-- case insensitive search
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true

vim.opt.wrap = false
vim.opt.formatoptions:append('r') -- smart comment inclusion

vim.opt.termguicolors = true

-- vim.opt.cursorline = true

-- Color the colum to the right of the limit
--vim.opt.colorcolumn = "+1"

--
--vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--  pattern = {"*.md", "*.mdx", "*.rst"},
--  callback = function()
--    vim.opt.spell = true
--  end
--})

-- show trailing whitespace
vim.opt.list = true
vim.opt.listchars = { tab = '⍿·',
                      trail = '●',
                      extends = '…',
                      precedes = '…' }
