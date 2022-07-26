local present, dap = pcall(require, "dap")
local present2, dapui = pcall(require, "dapui")
if not (present and present2) then
  return
end

dapui.setup()
require("nvim-dap-virtual-text").setup()
require("dap-go").setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "⭕", texthl = "", linehl = "", numhl = "" })

-- TODO: Reorganize adapters / configurations

-- Python

dap.adapters.python = {
  type = "executable",
  command = "python", -- As we are in poetry virtualenv
  args = { "-m", "debugpy.adapter" },
}

-- Golang

dap.adapters.go = function(callback, config)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = { nil, stdout },
    args = { "dap", "-l", "127.0.0.1:" .. port },
    detached = true,
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print("dlv exited with code", code)
    end
  end)
  assert(handle, "Error running dlv: " .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
  -- Wait for delve to start
  vim.defer_fn(function()
    callback({ type = "server", host = "127.0.0.1", port = port })
  end, 100)
end

-- Or if in any case I prefer to manually run the server
-- `dlv dap -l 127.0.0.1:38697 --log --log-output="dap"`
-- dap.adapters.go = {
--   type = "server",
--   host = "127.0.0.1",
--   port = 38697,
-- }

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
    console = "integratedTerminal",
  },
  {
    type = "go",
    name = "Debug test",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
  {
    type = "go",
    name = "Debug test logging (go.mod)",
    request = "launch",
    mode = "test",
    program = "./internal/logging/logging_test.go",
    args = {
      "-test.run",
      "^TestLogLevel$",
    },
  },
}

-- Chrome for JS/TS

dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = { os.getenv("HOME") .. "/projects/others/vscode-chrome-debug/out/src/chromeDebug.js" }, -- TODO adjust
}

dap.configurations.javascript = { -- change this to javascript if needed
  {
    type = "chrome",
    name = "Cypress",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
    skipFiles = { "cypress_runner.js" },
    urlFilter = "http://localhost*",
  },
}
dap.configurations.typescript = { -- change to typescript if needed
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input("Host [127.0.0.1]: ")
      if value ~= "" then
        return value
      end
      return "127.0.0.1"
    end,
    port = function()
      local val = tonumber(vim.fn.input("Port: "))
      assert(val, "Please provide a port number")
      return val
    end,
  },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host, port = config.port })
end
-- vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='', linehl='', numhl=''})
