local Self = {}

local kitty_directions = { left = "left", down = "bottom", up = "top", right = "right" }

local function kitty_run(command)
  vim.system({ "kitten", "@", unpack(command) }, { text = true }):wait()
end

local function build_resize_axis(direction)
  if direction == "left" or direction == "right" then
    return "horizontal"
  else
    return "vertical"
  end
end

local function build_resize_increment(direction, amount)
  if direction == "left" or direction == "up" then
    return "-" .. amount
  else
    return amount
  end
end

function Self.move_to(direction)
  kitty_run({ "focus-window", "-m", "neighbor:" .. kitty_directions[direction] })
end

function Self.resize_to(direction, amount)
  kitty_run({
    "resize-window",
    "--self",
    "--axis",
    build_resize_axis(direction),
    "--increment",
    build_resize_increment(direction, amount),
  })
end

return Self
