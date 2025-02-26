local M = {}

local function has_web_icon()
  return pcall(require, "nvim-web-devicons")
end

function M.get_file_icon(element)
  local has_icon, Icons = has_web_icon()
  if not has_icon then
    return nil, nil
  end

  return Icons.get_icon_by_filetype(element.filetype, {
    default = false,
  })
end

return M
