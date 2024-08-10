local commands = require("multiplex.commands")
local current = require("multiplex.current")

local Self = {}

Self.options = nil

local function with_defaults(options)
  return vim.tbl_deep_extend("force", {}, options or {})
end

function Self.setup(options)
  Self.options = with_defaults(options)

  current.setup()
  commands.create_commands()
end

return Self
