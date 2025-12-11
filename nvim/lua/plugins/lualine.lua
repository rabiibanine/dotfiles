return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Flexoki Colors
    local colors = {
      purple = "#8B7EC8", -- Your requested accent
      green = "#879A39",
      blue = "#4385BE",
      black = "#100F0F", -- Crust
      bg = "#1C1B1B", -- Base
      light = "#343331", -- Surface-2 (Lighter section)
      text = "#CECDC3",
      gray = "#878580",
    }
    local flexoki_custom = {
      normal = {
        a = { bg = colors.purple, fg = colors.black, gui = "bold" },
        b = { bg = colors.light, fg = colors.text },
        c = { bg = colors.bg, fg = colors.gray },
      },
      insert = {
        a = { bg = colors.green, fg = colors.black, gui = "bold" },
        b = { bg = colors.light, fg = colors.text },
        c = { bg = colors.bg, fg = colors.gray },
      },
      visual = {
        a = { bg = colors.blue, fg = colors.black, gui = "bold" },
        b = { bg = colors.light, fg = colors.text },
        c = { bg = colors.bg, fg = colors.gray },
      },
      replace = {
        a = { bg = colors.red, fg = colors.black, gui = "bold" },
        b = { bg = colors.light, fg = colors.text },
        c = { bg = colors.bg, fg = colors.gray },
      },
      inactive = {
        a = { bg = colors.bg, fg = colors.gray },
        b = { bg = colors.bg, fg = colors.gray },
        c = { bg = colors.bg, fg = colors.gray },
      },
    }
    -- Apply the theme
    opts.options.theme = flexoki_custom
  end,
}
