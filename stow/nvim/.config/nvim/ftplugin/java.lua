local root = vim.fs.root(0, '.git') or vim.fs.root(0, { 'pom.xml', 'build.gradle', 'build.gradle.kts' })
if not root or vim.fn.executable('jdtls') == 0 then
  return
end
local work = {}
local work_path = vim.fn.expand('~/.config/work-setup/nvim.lua')
if vim.fn.filereadable(work_path) == 1 then
  work = dofile(work_path)
end
local java = work.java or {}
local heap = vim.env.JDTLS_HEAP or java.heap or '2g'
local workspace = vim.fn.stdpath('cache') .. '/jdtls/' .. vim.fn.sha256(root):sub(1, 16)
local mason = vim.env.MASON or (vim.fn.stdpath('data') .. '/mason')
local bundles = vim.fn.glob(mason .. '/share/java-debug-adapter/*.jar', false, true)
vim.list_extend(bundles, vim.fn.glob(mason .. '/share/java-test/*.jar', false, true))
local seen, unique = {}, {}
for _, bundle in ipairs(bundles) do
  local real = vim.uv.fs_realpath(bundle) or bundle
  if not seen[real] then
    seen[real] = true
    table.insert(unique, real)
  end
end
bundles = unique
local settings = vim.tbl_deep_extend('force', {
  java = {
    signatureHelp = { enabled = true },
    saveActions = { organizeImports = true },
    completion = { maxResults = 20 },
    sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
  },
}, java.settings or {})
require('jdtls').start_or_attach({
  cmd = { 'jdtls', '--jvm-arg=-Xms256m', '--jvm-arg=-Xmx' .. heap, '-data', workspace },
  cmd_env = vim.env.JDTLS_JAVA_HOME and { JAVA_HOME = vim.env.JDTLS_JAVA_HOME } or nil,
  root_dir = root,
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = settings,
  init_options = { bundles = bundles },
})
