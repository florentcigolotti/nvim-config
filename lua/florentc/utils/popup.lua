local Job = require("plenary.job")
local win_float = require("plenary.window.float")

local M = {}

M.get_popup_settings = function()
  local percentage = 0.8
  local width = math.floor(vim.o.columns * percentage)
  local height = math.floor(vim.o.lines * percentage)
  local top = math.floor(((vim.o.lines - height) / 2) - 1)
  local left = math.floor((vim.o.columns - width) / 2)

  return {
    relative = "editor",
    row = top,
    col = left,
    width = width,
    height = height,
    style = "minimal",
    border = {
      { " ", "NormalFloat" },
      { " ", "NormalFloat" },
      { " ", "NormalFloat" },
      { " ", "NormalFloat" },
      { " ", "NormalFloat" },
      { " ", "NormalFloat" },
      { " ", "NormalFloat" },
      { " ", "NormalFloat" },
    },
  }
end

-- Old function
M.open_popup = function()
  local settings = M.get_popup_settings()

  -- Create a buffer for the floating window
  local bufnr = vim.api.nvim_create_buf(false, true)
  -- Create a floating window
  local win_id = vim.api.nvim_open_win(bufnr, true, settings)
  -- Set the buffer for the new floating window
  vim.api.nvim_win_set_buf(win_id, bufnr)

  vim.cmd("setlocal nocursorcolumn")
  vim.api.nvim_win_set_option(win_id, "winblend", 5)

  return bufnr, win_id
end

-- TODO: add a table for options to add for ex cwd
M.exec_in_old_popup = function(cmd, args)
  local bufnr, win_id = M.open_popup()

  -- Set keymaps on the specific popup buffer
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", {})
  -- Set filetype useful if you create a custom syntax
  vim.api.nvim_buf_set_option(bufnr, "filetype", "terminal")

  -- vim.api.nvim_win_set_option(win_id, "winhl", "Normal:Normal")
  vim.api.nvim_win_set_option(win_id, "conceallevel", 3)
  vim.api.nvim_win_set_option(win_id, "concealcursor", "n")

  Job
    :new({
      command = cmd,
      args = args,
      on_stdout = vim.schedule_wrap(function(_, data)
        M.nvim_output(bufnr, win_id, data)
        -- M.buf_scroll_to_last_line(bufnr, win_id)
      end),
      on_stderr = vim.schedule_wrap(function(_, data)
        M.nvim_output(bufnr, win_id, data)
        -- M.buf_scroll_to_last_line(bufnr, win_id)
      end),
      on_exit = vim.schedule_wrap(function(j, return_val, _)
        -- local results = j:stderr_result()
        -- print(unpack(results))
        -- M.nvim_output(bufnr, unpack(results))
        -- M.nvim_output(bufnr, unpack(j:result()))
        M.nvim_output(bufnr, win_id, "Exit code: " .. tostring(return_val))
        -- M.buf_scroll_to_last_line(bufnr, win_id)

        vim.cmd("mode")
      end),
    })
    :start()
end

-- must be schedule_wrapped
M.buf_scroll_to_last_line = function(bufnr, win_id)
  local lines = vim.api.nvim_buf_line_count(bufnr)
  vim.api.nvim_win_set_cursor(win_id, { lines, 0 })
end

M.nvim_output = vim.schedule_wrap(function(bufnr, win_id, ...)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  for _, v in ipairs({ ... }) do
    vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { v })
  end
  M.buf_scroll_to_last_line(bufnr, win_id)
end)

-- TODO: add a table for options to add for ex cwd
M.exec_in_popup = function(cmd, args)
  local res = win_float.percentage_range_window(0.95, 0.70, {})

  vim.api.nvim_buf_set_keymap(res.bufnr, "n", "q", ":q<CR>", {})
  vim.api.nvim_buf_set_option(res.bufnr, "filetype", "terminal")

  vim.api.nvim_win_set_option(res.win_id, "winhl", "Normal:Normal")
  vim.api.nvim_win_set_option(res.win_id, "conceallevel", 3)
  vim.api.nvim_win_set_option(res.win_id, "concealcursor", "n")

  if res.border_win_id then
    vim.api.nvim_win_set_option(res.border_win_id, "winhl", "Normal:Normal")
  end

  Job
    :new({
      command = cmd,
      args = args,
      on_stdout = vim.schedule_wrap(function(_, data)
        -- M.nvim_output(res.bufnr, data)
        -- M.buf_scroll_to_last_line(res.bufnr, res.win_id)
      end),
      on_stderr = vim.schedule_wrap(function(_, data)
        -- M.nvim_output(res.bufnr, data)
        -- M.buf_scroll_to_last_line(res.bufnr, res.win_id)
      end),
      on_exit = vim.schedule_wrap(function(j, return_val, _)
        local results = j:stderr_result()
        print(unpack(results))
        M.nvim_output(res.bufnr, res.win_id, unpack(results))
        -- M.nvim_output(res.bufnr, unpack(j:result()))
        M.nvim_output(res.bufnr, res.win_id, "Exit code: " .. tostring(return_val))

        vim.cmd("mode")
      end),
    })
    :start()
end

return M

