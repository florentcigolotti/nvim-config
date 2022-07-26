vim.cmd("packadd packer.nvim")

local plugins = {
  -- Core tools
  ["nvim-lua/plenary.nvim"] = {},
  ["wbthomason/packer.nvim"] = {},

  -- Treesitter
  ["nvim-treesitter/playground"] = {},
  ["nvim-treesitter/nvim-treesitter"] = {
    config = function()
      require("florentc.plugins.configs.treesitter")
    end,
  },
  ["nvim-treesitter/nvim-treesitter-textobjects"] = {},

  -- Visual
  ["nvim-lua/popup.nvim"] = {},
  ["norcalli/nvim-colorizer.lua"] = {},
  ["kyazdani42/nvim-web-devicons"] = {},
  ["rcarriga/nvim-notify"] = {
    config = function()
      vim.notify = require("notify")
    end,
  },
  -- Themes
  ["rebelot/kanagawa.nvim"] = {},
  -- Top / Bottom lines
  ["nvim-lualine/lualine.nvim"] = {
    config = function()
      require("florentc.plugins.configs.lualine")
    end,
  },
  ["akinsho/nvim-bufferline.lua"] = {
    config = function()
      require("florentc.plugins.configs.bufferline")
    end,
  },
  ["tiagovla/scope.nvim"] = {
    config = function()
      require("scope").setup()
    end,
  },

  -- Completion
  ["hrsh7th/nvim-cmp"] = {
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("florentc.plugins.configs.cmp")
    end,
  },

  -- Telescope
  ["nvim-telescope/telescope.nvim"] = {
    config = function()
      require("florentc.plugins.configs.telescope")
    end,
  },
  ["nvim-telescope/telescope-project.nvim"] = {},
  -- Previous time I start from stratch the make was not run
  -- TODO: check why it is not triggered
  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    run = "make",
  },
  ["rmagatti/session-lens"] = {
    requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
    config = function()
      require("session-lens").setup()
      require("florentc.plugins.configs.autosession")
    end,
  },
  ["jvgrootveld/telescope-zoxide"] = {},
  ["dhruvmanila/telescope-bookmarks.nvim"] = {
    requires = {
      "tami5/sqlite.lua",
    },
    commit = "eef8e53885525a6f2ddf98bff6b9fe17c263db6e",
  },

  -- Git
  ["lewis6991/gitsigns.nvim"] = {
    config = function()
      require("florentc.plugins.configs.gitsigns")
    end,
  },
  ["ruifm/gitlinker.nvim"] = {
    config = function()
      require("florentc.plugins.configs.gitlinker")
    end,
  },
  ["tpope/vim-fugitive"] = {},
  ["sindrets/diffview.nvim"] = {
    config = function()
      require("florentc.plugins.configs.diffview")
    end,
  },
  ["rhysd/committia.vim"] = {},
  ["ThePrimeagen/git-worktree.nvim"] = {
    config = function()
      require("florentc.plugins.configs.gitworktree")
    end,
  },

  -- lsp
  ["onsails/lspkind-nvim"] = {},
  ["folke/trouble.nvim"] = {
    config = function()
      require("florentc.plugins.configs.trouble")
    end,
  },
  ["j-hui/fidget.nvim"] = {
    config = function()
      require("fidget").setup()
    end,
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    config = function()
      require("florentc.plugins.configs.null_ls")
    end,
  },
  ["williamboman/mason.nvim"] = {
    requires = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("florentc.plugins.configs.lspconfig")
    end,
  },
  ["L3MON4D3/LuaSnip"] = {},
  ["ray-x/lsp_signature.nvim"] = {},

  -- Utils
  ["kyazdani42/nvim-tree.lua"] = {
    config = function()
      require("florentc.plugins.configs.nvimtree")
    end,
  },
  ["mg979/vim-visual-multi"] = {
    config = function()
      require("florentc.plugins.configs.others").visual_multi()
    end,
  },
  ["tomtom/tcomment_vim"] = {},
  ["tpope/vim-surround"] = {
    requires = { "tpope/vim-repeat" },
  },
  ["windwp/nvim-autopairs"] = {
    config = function()
      require("florentc.plugins.configs.others").autopairs()
    end,
  },
  ["michaeljsmith/vim-indent-object"] = {},
  ["editorconfig/editorconfig-vim"] = {},
  ["lewis6991/impatient.nvim"] = {},
  ["nvim-pack/nvim-spectre"] = {
    config = function()
      require("florentc.plugins.configs.spectre")
    end,
  },
  ["samjwill/nvim-unception"] = {},
  -- use({
  --   "smjonas/inc-rename.nvim",
  --   config = function()
  --     require("inc_rename").setup()
  --   end,
  -- })

  -- Dev
  -- Lua
  ["folke/lua-dev.nvim"] = {},
  -- Bitbake
  ["kergoth/vim-bitbake"] = {},
  -- Helm
  ["towolf/vim-helm"] = {},
  -- Cue
  ["jjo/vim-cue"] = {},
  -- Debugging
  ["rcarriga/nvim-dap-ui"] = {
    requires = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
      "leoluz/nvim-dap-go",
    },
    config = function()
      require("florentc.plugins.configs.dap")
    end,
  },
  ["jbyuki/one-small-step-for-vimkind"] = {},

  -- Testing zone
  ["voldikss/vim-floaterm"] = {
    requires = {},
  },
  ["nvim-neotest/neotest"] = {
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-plenary",
      "~/projects/perso/neotest-go",
      -- "nvim-neotest/neotest-go",
    },
    config = function()
      require("florentc.plugins.configs.neotest")
    end,
  },
  ["andythigpen/nvim-coverage"] = {
    requires = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("coverage").setup({
        lang = {
          go = {
            coverage_file = "cover.out.unit",
          }
        }
      })
    end,
  },
  -- TODO: There is a deprecated setting that is boring at startup
  -- ["rafaelsq/nvim-goc.lua"] = {
  --   config = function()
  --     require("nvim-goc").setup({
  --       verticalSplit = false,
  --     })
  --     vim.opt.switchbuf = "useopen"
  --   end,
  -- },
  ["stevearc/dressing.nvim"] = {
    config = function()
      require("dressing").setup()
    end,
  },
  ["tpope/vim-dadbod"] = {
    requires = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  -- ["ray-x/go.nvim"] = {
  --   requires = {
  --     "ray-x/guihua.lua",
  --   },
  --   config = function()
  --     -- require("go").setup()
  --   end,
  -- },
  -- use("tami5/lspsaga.nvim")
  ["ThePrimeagen/harpoon"] = {},
  ["TimUntersberger/neogit"] = {
    config = function()
      require("florentc.plugins.configs.neogit")
    end,
  },
  ["rafamadriz/friendly-snippets"] = {},
}

require("florentc.core.packer").run(plugins)
