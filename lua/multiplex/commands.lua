local notify = require("multiplex.notify")
local move = require("multiplex.move")
local resize = require("multiplex.resize")
local shell = require("multiplex.shell")

local Self = {}

local _commands = {
  ["run"] = shell.run,
  ["move"] = move.to,
  ["resize"] = resize.to,
}

function Self.create_commands()
  vim.api.nvim_create_user_command("Multiplex", function(opts)
    local current_level = _commands
    local command_args = {}

    for index, command in ipairs(opts.fargs) do
      if type(current_level) == "function" then
        table.insert(command_args, command)
      end

      if type(current_level) == "table" and current_level[command] then
        current_level = current_level[command]
      end

      if index == #opts.fargs and type(current_level) == "function" then
        local ok, result = pcall(current_level, unpack(command_args))

        if ok then
          return result
        end

        notify.err(string.format("Fail to run [%s]\n%s", opts.args, result))
        return false
      elseif index == #opts.fargs then
        notify.err("Invalid command: " .. opts.args)
        return false
      end
    end
  end, {
    nargs = "*",
    complete = function(_, line)
      local commands = vim.split(line, "%s+")
      local current_level = nil

      local completion = function(arg)
        local result = {}

        if not current_level or type(current_level) ~= "table" then
          return result
        end

        for key, _ in pairs(current_level) do
          table.insert(result, key)
        end

        if arg == "" then
          return result
        end

        return vim.tbl_filter(function(val)
          return vim.startswith(val, arg)
        end, result)
      end

      for index, command in ipairs(commands) do
        if index == 1 then
          current_level = _commands
        else
          if index == #commands then
            return completion(command)
          end

          if type(current_level) == "table" and current_level[command] ~= nil then
            current_level = current_level[command]
          else
            return completion(command)
          end
        end
      end
    end,
  })
end

return Self
