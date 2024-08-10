local Self = {}

Self.state = {
  multiplex = false,
}

function Self.setup()
  if os.getenv("TMUX") ~= nil then
    Self.state = {
      multiplex = true,
      program = "tmux",
      pane = os.getenv("TMUX_PANE"),
    }
  elseif os.getenv("ZELLIJ") ~= nil then
    Self.state = {
      multiplex = true,
      program = "zellij",
      pane = os.getenv("ZELLIJ_PANE_ID"),
    }
  elseif os.getenv("KITTY_LISTEN_ON") ~= nil then
    Self.state = {
      multiplex = true,
      program = "kitty",
      pane = nil,
    }
  end
end

function Self.program()
  if Self.state.multiplex then
    return Self.state.program
  else
    return nil
  end
end

function Self.pane()
  if Self.state.multiplex then
    return Self.state.pane
  else
    return nil
  end
end

return Self
