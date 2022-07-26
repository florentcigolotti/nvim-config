local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
  return
end

local options = {
  ensure_installed = "all",
  -- phpdoc compilation is failing for arch64
  ignore_install = { "phpdoc" },
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- For markdown
        -- TODO: Need to adapt queries/markdown/textobjects.scm before re-enable these
        -- ["icb"] = "@code_block.inner",
        -- ["acb"] = "@code_block.outer",
        -- ["ili"] = "@list_item.inner",
        -- ["ali"] = "@list_item.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]]"] = "@function.outer",
        -- ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]["] = "@function.outer",
        -- ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
        -- ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
        -- ["[]"] = "@class.outer",
      },
    },
  },
}

ts_config.setup(options)

-- Treesitter markdown testing
-- Disabled because this had been added into treesitter:
-- https://github.com/nvim-treesitter/nvim-treesitter/pull/2105
-- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
--
-- parser_configs.markdown = {
--   install_info = {
--     url = "https://github.com/ikatyang/tree-sitter-markdown",
--     files = { "src/parser.c", "src/scanner.cc" },
--   },
--   filetype = "markdown",
-- }
