local M = {}

M.autopairs = function()
  local present1, autopairs = pcall(require, "nvim-autopairs")
  local present2, cmp = pcall(require, "cmp")

  if not (present1 and present2) then
    return
  end

  local options = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  }

  autopairs.setup(options)

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.visual_multi = function()
  -- VisualMulti
  -- vim.api.nvim_set_var("VM_maps", {
  --   ["Add Cursor Up"] = "C-Up",
  --   ["Add Cursor Down"] = "C-Down",
  -- })
end

return M
