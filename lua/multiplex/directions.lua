local Self = {}

local valid_directions = { up = true, down = true, left = true, right = true }
local inverse_directions = { up = "down", down = "up", left = "right", right = "left" }

function Self.is_valid(direction)
  return valid_directions[direction] == true
end

function Self.inverse(direction)
  return inverse_directions[direction]
end

return Self
