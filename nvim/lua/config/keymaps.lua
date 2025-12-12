local keymap = vim.keymap

keymap.set("i", "kj", "<Esc>", { noremap = true, silent = true })
keymap.set("n", "<A-r>", function()
  local file = vim.fn.expand("%")
  local file_root = vim.fn.expand("%:r")
  local ft_cmds = {
    python = "python3 " .. file,
    javascript = "node " .. file,
    sh = "bash " .. file,
    c = "gcc " .. file .. " -o " .. file_root .. " && ./" .. file_root,
  }

  local cmd = ft_cmds[vim.bo.filetype]
  if cmd then
    -- Open a new terminal and run the current file.
    Snacks.terminal(
      cmd,
      { interactive = true, auto_close = false, win = { position = "bottom" }, cwd = vim.fn.expand("%:p:h") }
    )
  else
    print("No run command defined for " .. vim.bo.filetype)
  end
end, { desc = "Run File" })
