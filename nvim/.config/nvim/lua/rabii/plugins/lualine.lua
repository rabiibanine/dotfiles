return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "carbonfox",
      component_separators = "",
      section_separators = "",
      globalstatus = true,
    },
    sections = {
      lualine_c = { { "filename", path = 1 } }, -- relative path instead of just the filename
    },
  },
}
