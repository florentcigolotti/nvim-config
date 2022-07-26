local M = {}

M.bootstrap = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    print("Packer is not installed, let's install it!")
    -- Packer not installed, let's dot it
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    vim.cmd "packadd packer.nvim"
    require "florentc.plugins"
    vim.cmd "PackerSync"
  end
end

M.options = {
  max_jobs = 50,
  auto_clean = true,
  compile_on_sync = true,
  git = { clone_timeout = 6000 },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
}

M.run = function(plugins)
  local present, packer = pcall(require, "packer")
  if not present then
    return
  end

  packer.init(M.options)

  -- Format the plugins table
  -- TODO: Maybe I should just use directly the final table format
  local final_table = {}
  for key, _ in pairs(plugins) do
    plugins[key][1] = key
    table.insert(final_table, plugins[key])
  end
  -- ENHANCEMENT: I can for each plugin add a config key which require the
  -- config from plugins/configs/{pluginName}.lua

  require("packer").startup(function(use)
    for _, v in pairs(final_table) do
       use(v)
    end
  end)
end

M.packer_sync = function()
  local snap_shot_time = os.date("!%Y-%m-%dT%TZ")
  vim.cmd("PackerSnapshot " .. snap_shot_time)
  vim.cmd("PackerSync")
end

-- Custom PluginUpdate Ex command
-- It creates a snapshot then run PackerSync
vim.api.nvim_create_user_command("PluginUpdate", function()
  M.packer_sync()
end, {})

return M
