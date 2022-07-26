local present, nvimtree = pcall(require, "nvim-tree")
if not present then
  return
end

local options = {
  update_focused_file = {
    enable = true,
    update_cwd = false,
  },
  view = {
    adaptive_size = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  filters = { custom = { "^.git$" } },
}

nvimtree.setup(options)
