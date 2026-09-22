return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
		{ "<leader>o", "<cmd>Neotree focus<CR>", desc = "Focus file explorer" },
	},
	-- `init` runs at startup even though this plugin is lazy-loaded, which is
	-- what lets neo-tree take over when you do `nvim .` instead of netrw
	-- flashing up first (netrw itself is already disabled in options.lua).
	init = function()
		if vim.fn.argc(-1) == 1 then
			local arg = vim.fn.argv(0) --[[@as string]]
			local stat = (vim.uv or vim.loop).fs_stat(arg)
			if stat and stat.type == "directory" then
				require("neo-tree")
			end
		end
	end,
	opts = {
		close_if_last_window = true,
		filesystem = {
			follow_current_file = { enabled = true },
			hijack_netrw_behavior = "open_current",
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
			use_libuv_file_watcher = true,
		},
		window = {
			width = 32,
			mappings = {
				["<space>"] = "none", -- don't let neo-tree swallow your leader key
			},
		},
	},
}
