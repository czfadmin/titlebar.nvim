local M = {}

--- @param opts table
function M.set_autocmd(opts)
  if not opts.group or not opts.events then
    return
  end

  local group = vim.api.nvim_create_augroup(opts.group, {
    clear = true,
  })

  vim.api.nvim_create_autocmd(opts.events, {
    group = group,
    callback = function() end,
  })
end

return M
