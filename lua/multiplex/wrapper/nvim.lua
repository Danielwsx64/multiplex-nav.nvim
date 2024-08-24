local Self = {}

local nvim_directions = { up = "k", down = "j", left = "h", right = "l" }

local function winnr(direction)
  return vim.api.nvim_call_function("winnr", { direction })
end

local function resize_cmd(direction)
  if direction == "left" or direction == "right" then
    return "vertical resize"
  else
    return "horizontal resize"
  end
end

local function resize_amount(direction, amount)
  if direction == "left" or direction == "up" then
    return "-" .. amount
  else
    return "+" .. amount
  end
end

function Self.move_to(direction)
  local start_win = winnr()
  local nvim_direction = nvim_directions[direction]

  vim.api.nvim_command("wincmd " .. nvim_direction)

  return start_win ~= winnr()
end

function Self.resize_to(direction, amount)
  return vim.api.nvim_command(resize_cmd(direction) .. resize_amount(direction, amount))
end

function Self.is_alone_win()
  local win = winnr()

  for _, vim_direction in pairs(nvim_directions) do
    if win ~= winnr("1" .. vim_direction) then
      return false
    end
  end

  return true
end

function Self.is_nvim_border(direction)
  return winnr() == winnr("1" .. nvim_directions[direction])
end

return Self
