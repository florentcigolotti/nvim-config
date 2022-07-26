local present, telescope = pcall(require, "telescope")
if not present then
  return
end

local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local previewers_utils = require("telescope.previewers.utils")

local max_size = 100000
local truncate_large_files = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then
      return
    end
    if stat.size > max_size then
      local cmd = { "head", "-c", max_size, filepath }
      previewers_utils.job_maker(cmd, bufnr, opts)
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

local options = {
  defaults = {
    layout_strategy = "horizontal",
    prompt_prefix = " >",
    buffer_previewer_maker = truncate_large_files,
    -- file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    -- generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = { ".git/" },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        -- ["<esc>"] = actions.close,
      },
    },
    preview = {
      treesitter = false,
    },
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      -- show_all_buffers = false,
      -- theme = "dropdown",
      -- previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
      },
    },
    live_grep = {
      additional_args = function()
        return {
          "--hidden",
        }
      end,
    },
  },
  extensions = {
    fzf = {
      fuzzy = false, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    project = {
      base_dirs = {
        { "~/projects/onprem", max_depth = 2 },
        -- { "~/projects/onprem/go/src/sentryo.net", max_depth = 2 },
      },
    },
    bookmarks = {
      -- Available: 'brave', 'chrome', 'edge', 'firefox', 'safari'
      selected_browser = "firefox",
      url_open_command = "open",
      url_open_plugin = nil,
      full_path = true,
      -- firefox_profile_name = "default-release",
      firefox_profile_name = "tgar47sd.default-release",
    },
  },
}

telescope.setup(options)

local extensions = {
  "fzf",
  "project",
  "zoxide",
  "bookmarks",
  "notify",
  "dap",
  "git_worktree",
}

for _, e in pairs(extensions) do
  telescope.load_extension(e)
end

local config = require("florentc.core.config")
local M = {}

M.find_nvim_files = function()
  require("telescope.builtin").find_files({
    prompt_title = "dotfiles",
    cwd = config.dotfiles_path,
    find_command = { "fd", "--type", "f", "-uu", "-E", "packer_compiled.lua" },
    hidden = true,
  })
end

M.find_notes = function()
  require("telescope.builtin").find_files({
    prompt_title = "notes",
    cwd = config.note_paths[0],
    search_dirs = config.note_paths,
    hidden = true,
  })
end

-- Search feature files
M.find_features = function()
  require("telescope.builtin").find_files({
    prompt_title = "features",
    hidden = false,
    find_command = { "fd", "--type", "f", "-e", "feature" },
  })
end

M.project_files = function()
  local opts = {}
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

return M
