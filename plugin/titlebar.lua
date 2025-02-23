if vim.g.loaded_titlebar then
  return
end
vim.g.loaded_titlebar = true

-- 加载插件（它会自动初始化）
require("titlebar").setup()
