-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap

keymap.set("i", "kj", "<Esc>", { noremap = true, silent = true })
keymap.set("n", "<leader>r", function()
  local file = vim.fn.expand("%")
  local ft_cmds = {
    python = "python3 " .. file,
    javascript = "node " .. file,
    sh = "bash " .. file,
    go = "go run " .. file,
    rust = "cargo run",
  }

  local cmd = ft_cmds[vim.bo.filetype]
  if cmd then
    -- Open a terminal and run the command
    -- Note: 'snacks.terminal' is for newer LazyVim; use 'LazyVim.terminal' for older versions
    Snacks.terminal(cmd, { win = { position = "bottom" } })
  else
    print("No run command defined for " .. vim.bo.filetype)
  end
end, { desc = "Run File" })
