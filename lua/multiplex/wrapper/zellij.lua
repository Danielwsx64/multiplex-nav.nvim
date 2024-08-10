local Self = {}

function Self.move_to(direction)
  vim.system({ "zellij", "action", "move-focus", direction })
end

function Self.shell_run(command)
  vim.system({ "zellij", "run", "-f", "--", command })
end

return Self
