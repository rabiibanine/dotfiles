-- 1. Point to the .txt file (Raw ANSI), NOT the .lua file
-- Make sure this file actually exists at ~/.config/nvim/assets/jojo.txt
local art_file = vim.fn.stdpath("config") .. "/lua/plugins/assets/jojo.lua"

return {
  "folke/snacks.nvim",

  opts = {
    dashboard = {
      sections = {
        -- 3. The Art Section
        {
          section = "terminal",
          cmd = "cat " .. art_file,
          align = "center",
          padding = 1,
          height = 18,
        },

        preset = {},

        -- 4. Minimal Buttons
        { section = "keys", gap = 0, padding = 0 },
        { section = "startup", padding = 1 },
      },
    },
  },
}
