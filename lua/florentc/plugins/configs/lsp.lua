local M = {}

M.on_attach = function(client, bufnr)
  -- Disable formatting capabilities for tsserver to use only null-ls provider
  if client.name == "tsserver" then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end

  require("lsp_signature").on_attach({
    bind = true,
    handler_opts = {
      border = "single",
    },
  })

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings
  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- Disable this one because C-k is used for quickfix jumps
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  -- buf_set_keymap("n", "<space>rn", ":IncRename ", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- TODO: experiment with builtin and telescope find ref
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "gR", '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
  buf_set_keymap("n", "<space>m", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  -- buf_set_keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  -- buf_set_keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  -- if client.server_capabilities.document_formatting then
  buf_set_keymap("n", "<space>fd", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
  -- elseif client.server_capabilities.document_range_formatting then
  buf_set_keymap("n", "<space>ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  -- end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#3c3836
      hi LspReferenceText cterm=bold ctermbg=red guibg=#3c3836
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#3c3836
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end

  -- if client.server_capabilities.codeLensProvider then
  --   vim.notify("codelens is available", vim.lsp.log_levels.WARN)
  -- end
end

return M
