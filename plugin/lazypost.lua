if vim.g.loaded_lazypost then
  return
end
vim.g.loaded_lazypost = true

vim.api.nvim_create_user_command("LazyPost", function()
  require("lazypost").toggle()
end, { desc = "Toggle LazyPost" })
