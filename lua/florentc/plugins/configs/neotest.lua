local present, neotest = pcall(require, "neotest")
if not present then
  return
end

local options = {
  adapters = {
    require("neotest-plenary"),
    require("neotest-go"),
  },
}

neotest.setup(options)

-- Setup cmp in vim-dadbod
local cmp_present, cmp = pcall(require, "cmp")
if not cmp_present then
  return
end

vim.api.nvim_create_autocmd("FileType", {
  group = nil,
  pattern = "sql,mysql,plsql",
  callback = function()
    cmp.setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
  end,
})

