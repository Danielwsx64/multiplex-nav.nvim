if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("multiplex requires at least nvim-0.7.0.1")
  return
end
