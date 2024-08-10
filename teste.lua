local tt = { "ola" }
local t2 = { "mundo", unpack(tt) }

print(vim.inspect(t2))
