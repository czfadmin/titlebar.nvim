if vim.g.loaded_titlebar then
  return
end
vim.g.loaded_titlebar = true

require("titlebar").setup()
