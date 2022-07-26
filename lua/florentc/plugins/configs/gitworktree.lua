local present, gitworktree = pcall(require, "git-worktree")
if not present then
  return
end

local options = {
  update_on_change = true,
  -- update_on_change_command = ":NvimTreeOpen",
}

gitworktree.setup(options)
