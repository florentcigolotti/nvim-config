local present, spectre = pcall(require, "spectre")
if not present then
  return
end

local options = {
  mapping = {
    ["send_to_qf"] = {
      map = "<leader><leader>",
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = "send all item to quickfix",
    },
  },
}

spectre.setup(options)
