local Self = { _icon = "", name = "Multiplex" }

function Self.info(message)
  vim.notify(message, vim.log.levels.INFO, {
    title = Self.name,
    icon = Self._icon,
  })
end

function Self.warn(message)
  vim.notify(message, vim.log.levels.WARN, {
    title = Self.name,
    icon = Self._icon,
  })
end

function Self.err(message)
  vim.notify(message, vim.log.levels.ERROR, {
    title = Self.name,
    icon = Self._icon,
  })
end

function Self.debug(message)
  vim.notify(message, vim.log.levels.DEBUG, {
    title = Self.name,
    icon = Self._icon,
  })
end

return Self
