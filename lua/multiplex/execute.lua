local current = require("multiplex.current")
local notify = require("multiplex.notify")

local programs = {
  tmux = require("multiplex.wrapper.tmux"),
  zellij = require("multiplex.wrapper.zellij"),
  kitty = require("multiplex.wrapper.kitty"),
}

local Self = {}

function Self.call(fn_name, args)
  local program = current.program()

  if not program then
    notify.err("No multiplex program detected. Ensure the setup function was called.")
    return false
  end

  local fn = programs[program][fn_name]

  if type(fn) ~= "function" then
    notify.err("The function " .. fn_name .. " is not defined for wrapper " .. program)
    return false
  end

  local ok, result = pcall(fn, unpack(args))

  if ok then
    return result
  end

  notify.err("Failed to execute " .. program .. "." .. fn_name .. "() with args: " .. vim.inspect(args))

  return false
end

return Self
