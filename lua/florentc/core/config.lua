local config = {
  dotfiles_path = "$HOME/projects/perso/nvim-config",
  note_paths = {
    -- Personal notes
    "$HOME/projects/notes/content",
  },
  create_note_path = "$HOME/projects/notes/content/notes/",
  lspservers = {
    ["gopls"] = {
      settings = function()
        return {
          gopls = {
            -- Use gopls builtin gofumpt
            gofumpt = true,
          },
        }
      end,
    },
    ["ansiblels"] = {},
    ["bashls"] = {},
    ["clangd"] = {},
    ["cmake"] = {},
    ["diagnosticls"] = {},
    ["dockerls"] = {},
    ["eslint"] = {},
    ["golangci_lint_ls"] = {},
    ["html"] = {},
    ["jsonls"] = {},
    ["pyright"] = {},
    ["rust_analyzer"] = {},
    ["sumneko_lua"] = {
      -- Merge settings
      settings = function()
        -- local s = require("lua-dev").setup().settings

        local l = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        }

        -- local conf = vim.tbl_deep_extend("force", l, s)
        -- local conf = vim.tbl_deep_extend("force", s, l)

        return l
      end,
    },
    ["tsserver"] = {},
    ["yamlls"] = {},
  },
}

return config
