local M = {}

local utils = require("florentc.utils")
local api = vim.api

utils.map("v", "<leader>tt", '<cmd>lua require("florentc.core.format").format_table()<cr>')

M.format_table = function()
  -- TODO: length issue with symbols
  local function visual_selection_range()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
      return csrow - 1, cscol - 1, cerow - 1, cecol
    else
      return cerow - 1, cecol - 1, csrow - 1, cscol
    end
  end

  local csrow, _, cerow, _ = visual_selection_range()
  local lines = api.nvim_buf_get_lines(0, csrow, cerow + 1, false)

  local col_count = 0
  local table_size = {}
  for n, l in pairs(lines) do
    -- TODO: How to handle escaped | for Gherkin format
    local cols = vim.split(l, " |")

    -- First iteration, register the number of column
    if n == 1 then
      col_count = table.getn(cols)
      for i, c in pairs(cols) do
        table_size[i] = string.len(c)
      end
    else
      if table.getn(cols) ~= col_count then
        print("Error: Not equal number of column!")
        return
      end
      for i, c in pairs(cols) do
        local clength = string.len(c)
        if clength == 0 then
          goto continue
        end

        if clength > table_size[i] then
          table_size[i] = clength
        end

        ::continue::
      end
    end
  end

  -- Reconstruct the new table
  local new_table = {}
  for n, l in pairs(lines) do
    -- TODO: How to handle escaped | for Gherkin format
    local cols = vim.split(l, " |")
    -- First iteration, register the number of column
    new_table[n] = ""
    for i, c in pairs(cols) do
      local clength = string.len(c)
      if clength == 0 then
        goto continue
      end

      if clength < table_size[i] then
        -- Correct this colum
        new_table[n] = new_table[n] .. c .. string.rep(" ", table_size[i] - clength)
      else
        new_table[n] = new_table[n] .. c
      end

      if c ~= table.getn(cols) then
        new_table[n] = new_table[n] .. " |"
      end

      ::continue::
    end
  end

  -- Rewrite the new table
  api.nvim_buf_set_lines(0, csrow, cerow + 1, false, new_table)
end

return M
