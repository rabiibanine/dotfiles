local opt = vim.opt

-- Disable netrw now so it's out of the way once you add neo-tree later.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.scrolloff = 8
opt.wrap = false
opt.splitright = true
opt.splitbelow = true

-- Indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Files / undo
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Behavior
opt.mouse = "a"
opt.updatetime = 250
opt.timeoutlen = 300 -- keep this snappy so jk/kj don't feel delayed
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true

-- Whitespace characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
