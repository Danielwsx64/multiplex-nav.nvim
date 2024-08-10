local Self = {}

local kitty_directions = { left = "left", down = "bottom", up = "top", right = "right" }

local function kitty_run(command)
  vim.system({ "kitten", "@", unpack(command) }, { text = true }):wait()
end

function Self.move_to(direction)
  kitty_run({ "focus-window", "-m", "neighbor:" .. kitty_directions[direction] })
end

return Self
