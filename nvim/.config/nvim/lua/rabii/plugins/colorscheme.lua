return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				integrations = {
					lazy = true,
					lualine = true,
				},
			})

			vim.cmd.colorscheme("catppuccin-nvim")
		end,
	},
}
