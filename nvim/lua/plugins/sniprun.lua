return {
  "michaelb/sniprun",
  branch = "master",
  build = "sh ./install.sh",
  config = function()
    require("sniprun").setup()
  end,
  keys = {
    {
      "<leader>rr",
      "<cmd>let b:caret=winsaveview() <CR> | <cmd>%SnipRun <CR>| :call winrestview(b:caret) <CR>",
      mode = { "n" },
      desc = "Run File",
    },
    {
      "<C-r>",
      "<cmd>let b:caret=winsaveview() <CR> | <cmd>%SnipRun <CR>| :call winrestview(b:caret) <CR>",
      mode = { "n" },
      desc = "Run File",
    },
    {
      "<leader>rc",
      "<cmd>SnipClose<CR>",
      mode = { "n" },
      desc = "Close Output",
    },
    {
      "<C-x>",
      "<cmd>SnipClose<CR>",
      mode = { "n" },
      desc = "Close Output",
    },
  },
}
