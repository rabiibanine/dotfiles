return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000, -- load before everything else, it's the colorscheme
  config = function()
    require("nightfox").setup({
      options = {
        transparent = false,
        styles = {
          comments = "italic",
          keywords = "bold",
        },
      },
    })
    vim.cmd.colorscheme("carbonfox")
  end,
}
