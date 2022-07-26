local present, bufferline = pcall(require, "bufferline")
if not present then
  return
end

local options = {
  options = {
    mode = "buffers",
    numbers = "none",
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is deduplicated
    tab_size = 18,
    diagnostics = "nvim_lsp",
    separator_style = "thin",
  },
}

bufferline.setup(options)
