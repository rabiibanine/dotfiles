return {
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    config = function()
      -- Autocommand to force colors after theme load
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Flexoki Palette
          local purple = "#8B7EC8" 
          local text   = "#CECDC3" 
          local muted  = "#878580" 
          local yellow = "#D0A215" 
          local green  = "#879A39"
          local black  = "#100F0A" -- The Darkest Color (Crust)
          
          ---------------------------------------------------------
          -- 1. FOLDERS (Purple)
          ---------------------------------------------------------
          vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = purple, bold = true })
          vim.api.nvim_set_hl(0, "Directory", { fg = purple, bold = true })
          
          ---------------------------------------------------------
          -- 2. FILENAMES & TREE
          ---------------------------------------------------------
          vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = text })
          vim.api.nvim_set_hl(0, "SnacksPickerPath", { fg = text })
          vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = muted })
          vim.api.nvim_set_hl(0, "SnacksPickerTree", { fg = muted })
          
          ---------------------------------------------------------
          -- 3. GIT STATUS
          ---------------------------------------------------------
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = yellow })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = green })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = muted })

          ---------------------------------------------------------
          -- 4. THE DARKEST BACKGROUND (New!)
          ---------------------------------------------------------
          -- This removes the "Float" grey background and makes it pure black
          
          -- Main Picker Window
          vim.api.nvim_set_hl(0, "SnacksPickerNormal", { bg = black })
          vim.api.nvim_set_hl(0, "SnacksPickerBorder", { bg = black, fg = purple })
          
          -- The Input/Search Bar
          vim.api.nvim_set_hl(0, "SnacksPickerInput", { bg = black })
          vim.api.nvim_set_hl(0, "SnacksPickerInputTitle", { bg = black, fg = purple, bold = true })
          
          -- The Preview Window (Right side)
          vim.api.nvim_set_hl(0, "SnacksPickerPreview", { bg = black })
          vim.api.nvim_set_hl(0, "SnacksPickerPreviewBorder", { bg = black, fg = purple })
          
          -- Generic Floating Windows (Catch-all for other plugins)
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = black })
          vim.api.nvim_set_hl(0, "FloatBorder", { bg = black, fg = purple })
        end,
      })

      vim.cmd.colorscheme("flexoki")
    end,
  },
  
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "flexoki",
    },
  },
}