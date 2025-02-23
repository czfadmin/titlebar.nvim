local function has_web_icon()
  return pcall(require, "nvim-web-devicons")
end
