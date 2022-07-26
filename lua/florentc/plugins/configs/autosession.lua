local present, autosession = pcall(require, "auto-session")
if not present then
  return
end

local options = {
  log_level = "error",
  post_restore_cmds = { 'silent !kill -s SIGWINCH $PPID' }
}

autosession.setup(options)
