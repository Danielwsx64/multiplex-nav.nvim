local strings = require("multiplex.utils.strings")
local notify = require("multiplex.notify")
local current = require("multiplex.current")

local Self = {}

local state = { attached_pane = nil }

local function get_attached_pane()
  return state.attached_pane
end

-- local function set_attached_pane(pane)
--   state.attached_pane = pane
-- end

function Self.get_vim_pane_id()
  return current.pane()
end

local function is_vim_pane_id(test_id)
  return test_id == Self.get_vim_pane_id()
end

-- function Self.is_attached()
--   return is_pane_available_for_run(get_attached_pane())
-- end
--
-- function Self.panes_count()
--   return tonumber(get_info({ "window_panes" }))
-- end

local function send_keys(keys, target_pane)
  io.popen(string.format("tmux send-keys -t%s %s", target_pane, keys))
end

local function get_info(messages, target_pane)
  local full_message = ""

  for index, message in ipairs(messages) do
    if index == 1 then
      full_message = string.format("#{%s}", message)
    else
      full_message = string.format("%s:#{%s}", full_message, message)
    end
  end

  local display_message = string.format("display-message -p -F '%s'", full_message)

  return Self.run_command(display_message, target_pane)()
end

local function get_panes()
  local panes = {}

  local list = Self.run_command("list-panes")

  for line in list do
    local number = string.match(line, "(%d+):")

    if number then
      local id = string.match(line, "(%%%d+)")

      table.insert(panes, { id = id, number = number })
    end
  end

  return panes
end

local function is_valid_pane(target_pane)
  local ref = type(target_pane) == "table" and target_pane.id or target_pane

  for _, pane_info in ipairs(get_panes()) do
    if pane_info.id == ref or pane_info.number == ref then
      return true, pane_info
    end
  end

  return false, nil
end

local function is_pane_available_for_run(target_pane)
  if target_pane == nil then
    return false, nil
  end

  local available, info = is_valid_pane(target_pane)

  if (not available or not info) or is_vim_pane_id(info.id) then
    return false, nil
  end

  return available, info
end

local function current_major_orientation()
  local layout = get_info({ "window_layout" })

  if string.match(layout, "[[{]") == "{" then
    return "v"
  else
    return "h"
  end
end

local function is_in_copy_mode(pane_number)
  local tmux_copy_mode_num = 1

  local session_name = vim.trim(get_info({ "session_name" }))
  local window_index = vim.trim(get_info({ "window_index" }))

  local target = session_name .. ":" .. window_index .. "." .. pane_number

  return tonumber(get_info({ "pane_in_mode" }, target)) == tmux_copy_mode_num
end

function Self.run_command(command, target_pane)
  local line = string.format("tmux %s", command)

  if target_pane then
    line = string.format("%s -t '%s'", line, target_pane)
  end

  return io.popen(line):lines()
end

function Self.split(orientation)
  if orientation == "h" then
    Self.run_command("splitw -h")
  elseif orientation == "v" then
    Self.run_command("splitw -v")
  else
    Self.split(current_major_orientation())
  end

  return true
end

function Self.display_panes()
  Self.run_command("display-panes")
end

function Self.run_shell(command, pane_number)
  local run_into_pane = pane_number or get_attached_pane()
  local available_pane, pane_info = is_pane_available_for_run(run_into_pane)

  if not available_pane or pane_info == nil then
    notify.err("Specified panel is not available anymore: " .. vim.inspect(run_into_pane))
    return false
  end

  if is_in_copy_mode(pane_info.id) then
    -- quit copy mode
    send_keys("-X cancel", pane_info.id)
  else
    -- cancel any previous shell command in pane
    send_keys("C-c", pane_info.id)
  end

  send_keys(strings.shell_escape(command) .. " Enter", pane_info.id)

  return true
end

-- function Self.set_pane(pane)
--   local available_pane, pane_info = is_pane_available_for_run(pane)
--
--   if available_pane and pane_info ~= nil then
--     set_attached_pane(pane_info)
--
--     notify.info(string.format("Attached to pane #%s id: %s", pane_info.number, pane_info.id))
--     return true
--   else
--     notify.err("Pane not available for attach: " .. vim.inspect(pane))
--     return false
--   end
-- end
-- function Self.alt_pane()
--   for _, pane_info in ipairs(get_panes()) do
--     if not is_vim_pane_id(pane_info.id) then
--       return pane_info
--     end
--   end
-- end

-- function Self.resize_vim_pane(value)
--   if value == "z" or value == "Z" then
--     Self.run_command("resize-pane -Z", Self.get_vim_pane_id())
--
--     return true
--   end
--
--   value = tonumber(value)
--
--   if value then
--     Self.run_command(string.format("resize-pane -y%s%% -x%s%%", value, value), Self.get_vim_pane_id())
--
--     return true
--   end
--
--   return false
-- end

return Self
