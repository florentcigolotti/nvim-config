local present, lualine = pcall(require, "lualine")
if not present then
  return
end

local options = {
  options = { theme = "kanagawa" },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      { "diagnostics", sources = { "nvim_diagnostic" } },
      { require("auto-session-library").current_session_name },
      "filename",
    },
    lualine_x = {
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
}

lualine.setup(options)
