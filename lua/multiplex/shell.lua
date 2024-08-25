local notify = require("multiplex.notify")
local execute = require("multiplex.execute")

local Self = {}

Self.target_id = nil

local function ensure_available()
  if Self.target_id ~= nil and execute.call("is_pane_available", { Self.target_id }) then
    return true
  end

  local target_id = execute.call("select_pane_to_run", {})

  if target_id ~= nil then
    Self.target_id = target_id

    return true
  end

  return false
end

function Self.attach()
  local target_id = execute.call("select_pane_to_run", { { force = false } })

  if target_id ~= nil then
    Self.target_id = target_id

    notify.info("Attached to pane/window: #" .. target_id)
    return true
  end

  notify.err("Failed to attach to pane/window")
  return false
end

function Self.run(command)
  if ensure_available() then
    return execute.call("shell_run", { command, Self.target_id })
  end

  notify.err("No pane/window available to run command")
  return false
end

return Self
