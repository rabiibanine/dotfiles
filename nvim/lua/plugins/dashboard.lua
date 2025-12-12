-- 1. Point to the .txt file (Raw ANSI), NOT the .lua file
-- Make sure this file actually exists at ~/.config/nvim/assets/jojo.txt
local art_file = vim.fn.stdpath("config") .. "/lua/plugins/assets/jojo.txt"

return {
  "folke/snacks.nvim",

  -- 2. The "Nuclear" Fix for wrapping
  -- This runs an autocommand as soon as the plugin loads to force nowrap
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "snacks_dashboard",
      callback = function()
        vim.schedule(function()
          vim.opt_local.wrap = false
          vim.opt_local.spell = false
        end)
      end,
    })
  end,

  opts = {
    dashboard = {
      sections = {
        -- 3. The Art Section
        {
          section = "terminal",
          cmd = "cat " .. art_file,

          -- Dimensions (Make sure these are huge so it doesn't clip)
          height = 20,
          width = 100,

          padding = 1,
          indent = -8, -- Manually adjust this number to center it
        },

        -- 4. Minimal Buttons
        { section = "keys", gap = 0, padding = 1 },
        { section = "startup" },
      },
    },
  },
}

