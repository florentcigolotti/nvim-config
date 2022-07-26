local utils = require("florentc.utils")

local M = {}

M.load_mappings = function(conf)
  for mode, mappings in pairs(conf) do
    for mapping, cmd in pairs(mappings) do
      utils.map(mode, mapping, cmd)
    end
  end
end

M.general = {
  n = {
    -- Window navigation
    ["<C-h>"] = ":wincmd h<cr>",
    ["<C-j>"] = ":wincmd j<cr>",
    ["<C-k>"] = ":wincmd k<cr>",
    ["<C-l>"] = ":wincmd l<cr>",

    ["<C-Left>"] = ":vertical resize +3<cr>",
    ["<C-Right>"] = ":vertical resize -3<cr>",

    ["<leader>n"] = ":bnext<cr>",
    ["<leader>N"] = ":bprev<cr>",

    -- Window control
    ["<leader>wo"] = "<c-w><c-o>",

    -- Terminal
    ["<leader>tn"] = ":term<cr>",
    ["<leader>tv"] = ":vnew|term<cr>",
    ["<leader>tt"] = ":FloatermToggle<cr>",
    ["<leader>th"] = ":FloatermPrev<cr>",
    ["<leader>tl"] = ":FloatermNext<cr>",

    -- Quickfix list navigation
    ["<leader>j"] = ":cnext<cr>zz",
    ["<leader>k"] = ":cprev<cr>zz",

    -- Common (save, close, ...)
    ["<leader>s"] = ":w<cr>",
    ["<leader>q"] = ":bd<cr>",
    -- This one is actually better because it keeps window layout
    --[", "<leader>] =", ":bp\\|bd #<CR>",
    ["<Esc>"] = ":nohl<cr>",
    ["<leader>ch"] = ":nohl<cr>",

    -- Reload Neovim configuration
    ["<leader><cr>"] = ":luafile ~/.config/nvim/init.lua<cr>",
    ["<leader>r"] = ":source ~/.config/nvim/init.lua<cr>",
  },
  t = {
    -- In terminal mode, escape to exit insert mode
    ["<Esc>"] = "<c-\\><c-n>",
  },
}
M.load_mappings(M.general)

M.neotest = {
  n = {
    ["<leader>rt"] = ":lua require('neotest').run.run()<CR>",
    ["<leader>rr"] = ":lua require('neotest').run.run({strategy = 'dap'})<CR>",
    ["<leader>rf"] = ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
    ["<leader>ro"] = ":lua require('neotest').output.open()<CR>",
  },
}

M.load_mappings(M.neotest)

-- TODO: How to add options?
M.telescope = {
  n = {
    -- Builtin
    ["<leader>o"] = "<cmd>lua require('telescope.builtin').find_files()<cr>",
    ["<leader>b"] = "<cmd>lua require('telescope.builtin').buffers()<cr>",
    ["<leader>vd"] = "<cmd>lua require('telescope.builtin').diagnostics()<cr>",
    ["<leader>gb"] = "<cmd>lua require('telescope.builtin').git_branches()<cr>",
    ["<leader>fg"] = "<cmd>lua require('telescope.builtin').live_grep { hidden = false }<cr>",
    ["<leader>i"] = "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
    ["<leader>u"] = "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>",
    ["<leader>fw"] = ":Telescope grep_string search=<C-R><C-W><CR>",
    ["<leader>fp"] = ":lua require'telescope'.extensions.project.project{}<CR>",
    ["<leader>fh"] = "<cmd>lua require('telescope.builtin').help_tags()<cr>",
    ["<leader>fm"] = "<cmd>lua require('telescope.builtin').keymaps()<cr>",
    ["<leader>e"] = "<cmd>lua require('telescope.builtin').commands()<cr>",
    -- Personal
    ["<leader>p"] = "<cmd>lua require('florentc.plugins.configs.telescope').project_files()<CR>",
    ["<leader>df"] = "<cmd>lua require('florentc.plugins.configs.telescope').find_nvim_files()<cr>",
    ["<leader>fn"] = "<cmd>lua require('florentc.plugins.configs.telescope').find_notes()<cr>",
    ["<leader>fe"] = "<cmd>lua require('florentc.plugins.configs.telescope').find_envs()<cr>",
    -- ["<leader>ff"] = "<cmd>lua require('florentc.plugins.configs.telescope').find_features()<cr>",
    -- Plugins
    ["<leader>fs"] = '<cmd>lua require("session-lens").search_session()<cr>',
    -- TODO: There is a conflict with format file
    ["<leader>ff"] = '<cmd>lua require("telescope").extensions.bookmarks.bookmarks()<cr>',
    ["<leader>cd"] = '<cmd>lua require("telescope").extensions.zoxide.list{}<cr>',
    ["<leader>gw"] = '<cmd>lua require("telescope").extensions.git_worktree.git_worktrees()<cr>',
  },
}
M.load_mappings(M.telescope)

M.others = {
  n = {
    -- Exec current lua file
    ["<leader>d"] = ":luafile %<cr>",
    ["<leader>af"] = ":luafile test.lua<cr>",

    -- NvimTree
    -- TODO: How to add options, need to adapt structure?
    ["<leader>vv"] = ":NvimTreeToggle<CR>",
    -- { noremap = true, silent = false },

    -- Spectre
    ["<leader>F"] = "<cmd>lua require('spectre').open()<cr>",
    ["<leader>S"] = "<cmd>lua require('spectre').open_visual({select_word=true})<cr>",

    -- Create a new note
    ["<leader>cn"] = '<cmd>lua require("florentc.keymaps").create_new_note()<cr>',
  },
}
M.load_mappings(M.others)

----------------
-- Fugitive
M.git_push_to_current = function()
  if vim.fn.input("Confirm Git push? ") == "Y" then
    vim.api.nvim_command("Git -c push.default=current push")
  end
end

M.git = {
  n = {
    ["<leader>gl"] = ":G log<CR>",
    ["<Leader>gs"] = "<cmd>Git<CR>",
    ["<Leader>ggs"] = "<cmd>Git stash<CR>",
    ["<Leader>ggp"] = "<cmd>Git stash pop<CR>",
    ["<leader>gp"] = '<cmd>lua require("florentc.core.mappings").git_push_to_current()<cr>',
  },
}
M.load_mappings(M.git)

-- Git linker
M.gitlinker = {
  n = {
    ["<leader>gY"] = '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
  },
}
M.load_mappings(M.gitlinker)

-- Diffview

M.diffview = {
  n = {
    ["<leader>gd"] = ":DiffviewOpen<CR>",
    ["<leader>gh"] = ":DiffviewFileHistory<CR>",
  },
}
M.load_mappings(M.diffview)

M.dap = {
  n = {
    ["<leader>db"] = "<cmd>lua require('dap').toggle_breakpoint()<cr>",
    ["<leader>dd"] = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
    ["<leader>dp"] = "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
    ["<leader>dl"] = "<cmd>lua require('dap').run_last()<cr>",
    ["<leader>dc"] = "<cmd>lua require('dap').continue()<cr>",
    ["<leader>dn"] = "<cmd>lua require('dap').step_over()<cr>",
    ["<leader>di"] = "<cmd>lua require('dap').step_into()<cr>",
    ["<leader>do"] = "<cmd>lua require('dap').step_out()<cr>",
    ["<leader>da"] = "<cmd>lua require('dap').close()<cr>",
    ["<leader>dh"] = "<cmd>lua require('dapui').eval(nil, { enter = true })<cr>",
  },
}
M.load_mappings(M.dap)

-- Trouble

utils.map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true })
utils.map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true })
utils.map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true })
utils.map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true })
utils.map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true })
-- utils.map("n", "gr", "<cmd>TroubleToggle lsp_references<cr>", { silent = true })

M.create_new_note = function()
  local present, config = pcall(require, "florentc.core.config")
  if not present then
    return
  end
  local name = vim.fn.input("Note name: ")
  if name == "" then
    print("Create note cancelled")
    vim.api.nvim_command("silent")
    return
  end

  local noteFile = config.create_note_path .. name .. ".md"
  local command = "e " .. noteFile
  vim.api.nvim_command(command)
end

return M
