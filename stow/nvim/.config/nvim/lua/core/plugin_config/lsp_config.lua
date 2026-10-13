require('mason').setup()
local servers = { 'bashls', 'clangd', 'cmake', 'cssls', 'dockerls', 'jsonls', 'lua_ls', 'marksman', 'pyright', 'rust_analyzer', 'yamlls', 'jqls', 'taplo' }
local installed = vim.list_extend(vim.deepcopy(servers), { 'jdtls' })
require('mason-lspconfig').setup({
  ensure_installed = vim.env.DOTFILES_OFFLINE == '1' and {} or installed,
  automatic_enable = false, -- Java has one owner: ftplugin/java.lua.
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, server in ipairs(servers) do
  vim.lsp.config(server, { capabilities = capabilities })
end
vim.lsp.config('lua_ls', { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } })
vim.lsp.enable(servers)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(event)
    vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
    vim.keymap.set('n', 'gl', require('telescope.builtin').diagnostics, opts)
    vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ga', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})
