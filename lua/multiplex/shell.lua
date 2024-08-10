local execute = require("multiplex.execute")

local Self = {}

function Self.run(command)
  execute.call("shell_run", { command })
end

return Self
