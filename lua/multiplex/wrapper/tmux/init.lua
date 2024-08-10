local runner = require("multiplex.wrapper.tmux.runner")
local Self = {}

local tmux_directions = { left = "L", down = "D", up = "U", right = "R" }

function Self.move_to(direction)
  runner.run_command("select-pane -" .. tmux_directions[direction], runner.get_vim_pane_id())
end

return Self
