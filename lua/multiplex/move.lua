local notify = require("multiplex.notify")
local nvim = require("multiplex.wrapper.nvim")
local execute = require("multiplex.execute")

local Self = {}

local valid_directions = { up = true, down = true, left = true, right = true }

function Self.to(direction)
  if not valid_directions[direction] then
    notify.err("Invalid direction " .. direction)

    return false
  end

  if not nvim.move_to(direction) then
    return execute.call("move_to", { direction })
  end
end

return Self
