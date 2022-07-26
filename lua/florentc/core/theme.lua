-- Color scheme
-- TODO: This should not be here as it can fail at bootstrap

local present, colorizer = pcall(require, "colorizer")
if present then
  colorizer.setup()
end

local present2, kanagawa = pcall(require, "kanagawa")
if not present2 then
    return
end

-- local default_colors = require("kanagawa.colors").setup()
local my_colors = {
  -- sumiInk1 = "black",
  -- fujiWhite = "#EDEDD5",
  -- bg = "#272727",
  -- -- popup background
  -- waveBlue1 = default_colors.sumiInk0,
  -- -- oniViolet = default_colors.roninYellow,
  -- oniViolet = default_colors.autumnYellow,
}

kanagawa.setup({
  undercurl = true,
  commentStyle = { italic = true },
  functionStyle = {},
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  typeStyle = {},
  variablebuiltinStyle = { italic = true },
  specialReturn = true,
  specialException = true,
  transparent = false,
  dimInactive = false,
  colors = my_colors,
  overrides = {},
  globalStatus = true,
})

vim.cmd([[colorscheme kanagawa]])
-- local utils = require("florentc.utils")
-- utils.opt("o", "background", "dark")

vim.cmd([[highlight NvimTreeVertSplit guibg=None guifg=#16161D]])
vim.cmd([[highlight CmpBorder guibg=None guifg=#727169]])
