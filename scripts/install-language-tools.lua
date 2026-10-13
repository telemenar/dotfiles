-- Headless MasonInstall blocks until completion. Install only missing tools.
local registry = require('mason-registry')
registry.refresh()
local mapping = require('mason-lspconfig.mappings').get_mason_map().lspconfig_to_package
local servers = { 'bashls', 'clangd', 'cmake', 'cssls', 'dockerls', 'jsonls', 'lua_ls', 'marksman', 'pyright', 'rust_analyzer', 'yamlls', 'jqls', 'taplo', 'jdtls' }
local missing = {}
for _, server in ipairs(servers) do
  local name = assert(mapping[server], 'No Mason package mapping for ' .. server)
  if not registry.get_package(name):is_installed() then
    table.insert(missing, name)
  end
end
for _, name in ipairs({ 'java-debug-adapter', 'java-test' }) do
  if not registry.get_package(name):is_installed() then
    table.insert(missing, name)
  end
end
if #missing > 0 then
  vim.cmd('MasonInstall ' .. table.concat(missing, ' '))
end
