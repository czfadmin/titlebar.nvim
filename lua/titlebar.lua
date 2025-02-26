local M = {}

_G.__tabbar_private = _G.__tabbar_private or {}

-- 设置默认配置
M.options = {
  separator_style = "thin",
  show_file_path = true,
  show_modified = true,
  show_encoding = true,
  show_filetype = true,
  file_path_type = "absolute",
  show_project_name = true,
  show_diagnostics = true,
  show_buf_id = false,

  -- navigation = {
  --   enabled = true,
  --   icons = {
  --     back = "  ",
  --     forward = "  ",
  --   },
  -- },
  --
  theme = {
    enabled = true,
    icons = {
      light = " ",
      dark = " ",
    },
  },
  colors = {},
  icons = {
    modified = " ● ",
    lock = "  ",
  },
}

-- 获取当前文件信息
local function get_file_info()
  local file_name = vim.fn.expand("%:t")
  local file_path = vim.fn.expand("%:p:h")
  local modified = vim.bo.modified
  local readonly = vim.bo.readonly
  local filetype = vim.bo.filetype
  local encoding = vim.bo.fileencoding

  return {
    name = file_name ~= "" and file_name or "[No Name]",
    path = file_path,
    modified = modified,
    readonly = readonly,
    filetype = filetype ~= "" and filetype or "no ft",
    encoding = encoding ~= "" and encoding or "utf-8",
  }
end

local function get_file_icon(element)
  local has_icon, Icons = pcall(require, "nvim-web-devicons")
  if not has_icon then
    return nil, nil
  end

  return Icons.get_icon_by_filetype(element.filetype, {
    default = false,
  })
end

-- 生成标签栏内容
local function generate_tabline()
  local info = get_file_info()
  local left_components = {}

  local middle_components = {}

  -- 获取当前窗口宽度
  -- local window_width = vim.api.nvim_win_get_width(0)
  local window_width = vim.api.nvim_get_option_value("columns", {})

  -- 中间组件:
  -- 显示文档错误
  if M.options.show_diagnostics then
    -- table.insert(list, pos, value)
  end

  table.insert(middle_components, "%=")

  -- if M.options.navigation.enabled then
  --   table.insert(
  --     middle_components,
  --     "%#TabLine#" .. M.options.navigation.icons.back .. "%#TabLine#" .. M.options.navigation.icons.forward .. " "
  --   )
  -- end

  -- 修改标记
  if M.options.show_modified and info.modified then
    table.insert(middle_components, "%#TabLineModified#" .. M.options.icons.modified)
  end

  -- 文件类型
  if M.options.show_filetype then
    local icon, hl = get_file_icon(info)
    icon = (icon or "") .. " "
    if hl then
      table.insert(middle_components, "%#" .. hl .. "#" .. icon)
    end
  end

  -- 文件名
  local file_name_component = "%#TabLineSel#" .. (info.name or "") .. " "

  table.insert(middle_components, file_name_component)

  -- 文件路径
  if M.options.show_file_path then
    table.insert(middle_components, "%#TabLine# ~ ")
    local file_path = M.options.file_path_type == "absolute" and info.path or vim.fn.fnamemodify(info.path, ":~") -- 根据配置选择路径类型
    table.insert(middle_components, "%#TabLine# " .. file_path .. " ")
  end

  -- 锁图标
  if info.readonly then
    table.insert(middle_components, "%#TabLine#" .. M.options.icons.lock)
  end

  -- 将文件编码和主题图标放置到最右侧
  local right_components = {}

  table.insert(right_components, "%=")

  if M.options.theme.enabled then
    local theme_icon = M.options.current_theme == "light" and M.options.theme.icons.dark or M.options.theme.icons.light
    -- 右对齐右面的组件
    table.insert(right_components, "%@v:lua.__tabbar_private.toggle_theme@" .. "%#TabLine#" .. theme_icon)
  end

  -- 组合所有部分
  local tabline = table.concat({
    table.concat(left_components, ""),
    table.concat(middle_components, ""),
    table.concat(right_components, ""),
  }, "")

  return tabline -- 返回拼接后的字符串
end

-- 设置高亮组
local function set_highlights()
  -- local colors = M.options.colors or {}
  --
  -- vim.api.nvim_command("hi TitlebarPath guifg=" .. colors.foreground .. " guibg=" .. colors.background)
  -- vim.api.nvim_command("hi TitlebarFileName guifg=" .. colors.foreground .. " guibg=" .. colors.background)
  -- vim.api.nvim_command("hi TitlebarModified guifg=" .. colors.modified .. " guibg=" .. colors.background)
  -- vim.api.nvim_command("hi TitlebarFileType guifg=" .. colors.foreground .. " guibg=" .. colors.background)
  -- vim.api.nvim_command("hi TitlebarEncoding guifg=" .. colors.foreground .. " guibg=" .. colors.background)
end

-- 切换主题
local function toggle_theme()
  M.options.current_theme = M.options.current_theme == "dark" and "light" or "dark"
  vim.o.background = M.options.current_theme
  vim.o.tabline = generate_tabline() -- 更新标签栏内容
end

local function set_autocmds()
  local group = vim.api.nvim_create_augroup("czfadmin.titlebar.tabline", {
    clear = true,
  })
  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufModifiedSet",
    "WinEnter",
  }, {
    group = group,
    callback = function()
      vim.o.tabline = generate_tabline() -- 更新标签栏内容
    end,
  })

  vim.api.nvim_create_autocmd({
    "VimResized",
  }, {
    group = vim.api.nvim_create_augroup("czfadmin.titlebar.vimresized", {
      clear = true,
    }),
    callback = function()
      vim.o.tabline = generate_tabline()
    end,
  })
end

-- 设置标签栏
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  M.options.current_theme = M.options.current_theme or "dark" -- 默认主题

  -- 设置高亮
  set_highlights()

  -- 设置标签栏
  vim.o.tabline = "%{luaeval('require(\"titlebar\").get_tabline()')}"

  -- 在当前窗口中打开标签栏
  M.open_in_window(0) -- 0 表示当前窗口

  set_autocmds()
end

-- 获取标签栏内容
function M.get_tabline()
  return generate_tabline()
end

-- 在指定窗口中打开标签栏
function M.open_in_window(window_id)
  vim.api.nvim_win_set_var(window_id, "tabline", "%{luaeval('require(\"titlebar\").get_tabline()')}")
end

_G.__tabbar_private.toggle_theme = toggle_theme

return M
