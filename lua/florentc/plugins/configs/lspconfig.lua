local M = {}

-- Set diagnistic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- For jsonls to work, we need to specify snippet capability
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local config = require("florentc.core.config")
local servers = {}

for k, _ in pairs(config.lspservers) do
  table.insert(servers, k)
end

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = servers,
}

local lspconfig = require("lspconfig")
local lsp = require("florentc.plugins.configs.lsp")

M.add_lspconfig = function(server, settings, on_attach, capa)
  lspconfig[server].setup({
    settings = settings,
    on_attach = on_attach,
    capabilities = capa,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

for s, c in pairs(config.lspservers) do
  local settings
  if c.settings == nil then
    settings = {}
  else
    settings = c.settings()
  end

  M.add_lspconfig(s, settings, lsp.on_attach, capabilities)
end

-- Golang

-- See here: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports
function OrgImports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

vim.api.nvim_create_augroup("goFileType", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    OrgImports(1000)
  end,
})

return M
