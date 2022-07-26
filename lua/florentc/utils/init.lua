local utils = {}

local scopes = {
  o = vim.o, -- global editor options
  b = vim.bo, -- buffer-scoped options
  w = vim.wo, -- window-scoped options
}

function utils.opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= "o" then
    scopes["o"][key] = value
  end
end

function utils.map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

return utils
