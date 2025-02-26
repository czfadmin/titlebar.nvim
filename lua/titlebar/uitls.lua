local M = {}

function M.get_file_info()
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

return M
