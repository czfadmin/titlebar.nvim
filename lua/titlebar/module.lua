local M = {}

local default_option = {
  separator_style = "thin",
  show_file_path = true,
  show_modified = true,
  show_encoding = true,
  show_filetype = true,
  file_path_type = "absolute",
  show_project_name = true,
  show_diagnostics = true,
  show_buf_id = false,

  navigation = {
    enabled = true,
    icons = {
      back = "  ",
      forward = "  ",
    },
  },

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

M.option = {}

function M.setup(opts)
  M.option = vim.tbl_deep_extend("force", M.option, opts or default_option)
end

---
--- 新增插入一个组件
--- @param opts table
---
function M.insert(opts) end

return M
