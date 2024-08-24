local notify = require("multiplex.notify")
local directions = require("multiplex.directions")
local nvim = require("multiplex.wrapper.nvim")
local execute = require("multiplex.execute")

local Self = {}

function Self.to(direction, amount, opts)
  amount = amount or "1"

  if not directions.is_valid(direction) then
    notify.err("Invalid direction " .. direction)

    return false
  end

  if nvim.is_alone_win() or opts == "force_multiplex" then
    return execute.call("resize_to", { direction, amount })
  else
    nvim.resize_to(direction, amount)
  end
end

return Self
