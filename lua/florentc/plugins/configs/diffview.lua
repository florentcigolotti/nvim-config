local present, diffview = pcall(require, "diffview")
if not present then
  return
end

local options = {
  key_bindings = {
    file_history_panel = { q = "<Cmd>DiffviewClose<CR>" },
    file_panel = { q = "<Cmd>DiffviewClose<CR>" },
    view = { q = "<Cmd>DiffviewClose<CR>" },
  },
  default_args = {
    DiffviewOpen = { "--untracked-files=no", "--imply-local" },
  },
}

diffview.setup(options)
