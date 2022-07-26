local utils = require("florentc.utils")

local opt = vim.opt

vim.g.mapleader = " "
opt.number = true
opt.relativenumber = true
-- utils.opt("o", "guicursor", "")
opt.showmatch = false
opt.hlsearch = true
utils.opt("o", "hidden", true)
opt.hidden = true
opt.errorbells = false
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.nu = true
opt.wrap = false
opt.smartcase = true
opt.swapfile = false
opt.backup = false
utils.opt("o", "undodir", vim.env.HOME .. "/.vim/undodir")
opt.undofile = true
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.inccommand = "nosplit"
opt.cmdheight = 1
opt.updatetime = 50
opt.wrap = true
opt.splitright = true
opt.cul = true
opt.laststatus = 3
-- opt.fillchars:append({
--   horiz = "━",
--   horizup = "┻",
--   horizdown = "┳",
--   vert = "┃",
--   vertleft = "┨",
--   vertright = "┣",
--   verthoriz = "╋",
-- })

-- highlight line in current buffer only
vim.opt.cursorline = true
local group = vim.api.nvim_create_augroup("CursorLineControl", { clear = true })
local set_cursorline = function(event, value, pattern)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = function()
      vim.opt_local.cursorline = value
    end,
  })
end
set_cursorline("WinEnter", true)
set_cursorline("WinLeave", false)
set_cursorline("FileType", false, "TelescopePrompt")

-- Use the system clipboard (+)
utils.opt("o", "clipboard", "unnamedplus")

if vim.fn.exists("+termguicolors") then
  utils.opt("o", "termguicolors", true)
end

-- systemd
vim.cmd([[autocmd BufNewFile,BufRead *.service* set ft=systemd]])
-- hosts file
vim.cmd([[autocmd BufNewFile,BufRead hosts set ft=dosini]])
