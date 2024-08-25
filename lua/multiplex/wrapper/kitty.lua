local current = require("multiplex.current")

local Self = {}

local kitty_directions = { left = "left", down = "bottom", up = "top", right = "right" }

local function kitty_run(command, opt)
  opt = opt or {}

  local result = vim.system({ "kitten", "@", unpack(command) }, { text = true }):wait()

  if result.code == 0 then
    if opt.trim then
      return vim.trim(result.stdout)
    end

    return result.stdout
  end
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

local function build_id(id)
  return 'id:"' .. id .. '"'
end

function Self.is_pane_available(id)
  if kitty_run({ "ls", "--match", build_id(id) }) then
    return true
  else
    return false
  end
end

function Self.select_pane_to_run(opt)
  opt = opt or { force = true }
  local candidate = kitty_run(
    { "select-window", "--self", "--exclude-active", "--title", "Select window for run vim commands" },
    { trim = true }
  )

  if candidate and current.pane() ~= candidate then
    return candidate
  end

  if opt.force then
    kitty_run({ "launch", "--keep-focus" })

    candidate = kitty_run(
      { "select-window", "--self", "--exclude-active", "--title", "Select window for run vim commands" },
      { trim = true }
    )

    if candidate and current.pane() ~= candidate then
      return candidate
    end
  end
end

function Self.shell_run(cmd_str, id)
  kitty_run({ "send-key", "--match", build_id(id), "ctrl+c" })
  return kitty_run({ "send-text", "--match", build_id(id), "clear;" .. cmd_str .. "\x0d" })
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
