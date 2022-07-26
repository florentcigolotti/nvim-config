local present, gitlinker = pcall(require, "gitlinker")
if not present then
  return
end

local options = {
  callbacks = {},
}

gitlinker.setup(options)
