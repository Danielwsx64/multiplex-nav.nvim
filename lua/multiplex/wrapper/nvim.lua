local Self = {}

local nvim_directions = { up = "k", down = "j", left = "h", right = "l" }

function Self.move_to(direction)
  local start_win = vim.fn.winnr()
  local nvim_direction = nvim_directions[direction]

  vim.api.nvim_command("wincmd " .. nvim_direction)

  return start_win ~= vim.fn.winnr()
end

return Self
