local present, null_ls = pcall(require, "null-ls")
if not present then
  return
end

-- TODO: lsp_signature require check
-- TODO: treesitter require check
-- TODO: lspconfig plugin require check

local lsp = require("florentc.plugins.configs.lsp")

local options = {
  log = {
    enable = true,
    level = "warn",
    use_console = "async",
  },
  on_attach = lsp.on_attach,
  sources = {
    -- lua
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.selene,
    -- bash
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.formatting.shellharden,
    -- js and co
    null_ls.builtins.formatting.prettier,
    -- python
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
    -- yaml
    -- null_ls.builtins.diagnostics.yamllint,
    -- sql
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.diagnostics.sqlfluff,
  },
}

null_ls.setup(options)

null_ls.builtins.diagnostics.sqlfluff.with({
  extra_args = { "--dialect", "postgres" },
})

local testrail_tc_duplicate_detector = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "javascript" },
  generator = {
    fn = function(params)
      local diagnostics = {}

      local ts = vim.treesitter
      local ts_utils = require("nvim-treesitter.ts_utils")

      local query = [[
  (call_expression
    function: (identifier) @func
    (#match? @func "it")
    arguments: (arguments
      (string
        (string_fragment) @text)) @args)
]]

      local parsed_query = ts.parse_query(params.ft, query)
      local parser = ts.get_parser(params.bufnr)
      local root = parser:parse()[1]:root()
      local start_row, _, end_row, _ = root:range()

      -- Iter over captures
      for id, node in parsed_query:iter_captures(root, params.bufnr, start_row, end_row) do
        local name = parsed_query.captures[id] -- name of the capture in the query

        -- Working on @args only
        if name == "args" then
          -- Do work only on "it" functions with 3 arguments
          if node:named_child_count() == 3 then
            -- Gets all named children of the arguments node which gives a table of all arguments
            local args = ts_utils.get_named_children(node)

            -- Check args types
            if args[1]:type() == "array" and args[2]:type() == "string" and args[3]:type() == "arrow_function" then
              local arg1 = args[1]
              local arg1_children = ts_utils.get_named_children(arg1)

              local array_case_id = nil

              -- Inspect the array
              for _, element in ipairs(arg1_children) do
                local e_content = ts_utils.get_named_children(element)
                local value = ts_utils.get_node_text(e_content[1])
                array_case_id = value[1]
              end

              if array_case_id ~= nil then
                -- Get arg2 content
                local arg2_content = ts_utils.get_node_text(args[2])[1]

                if string.find(arg2_content, array_case_id) then
                  local error_msg = "More than 1 definition of the case id " .. array_case_id

                  local row, start_col, _, end_col = node:range()

                  table.insert(diagnostics, {
                    row = row + 1,
                    col = start_col - 1,
                    end_col = end_col - 1,
                    source = "testrail_tc_duplicate_detector",
                    message = error_msg,
                    severity = 2,
                  })
                end
              end
            end
          end
        end
      end

      return diagnostics
    end,
  },
}

null_ls.register(testrail_tc_duplicate_detector)
