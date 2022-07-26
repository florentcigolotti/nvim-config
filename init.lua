local present, reload = pcall(require, "plenary.reload")
if present then
  reload.reload_module("florentc", true)
end

require("florentc.core")
require("florentc.core.packer").bootstrap()
require("florentc.plugins")
