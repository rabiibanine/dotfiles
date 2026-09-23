return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "carbonfox",
			component_separators = "",
			section_separators = "",
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" }, -- lualine's own default already includes a branch icon
			lualine_c = {
				{
					-- file-type icon, pulled straight from nvim-web-devicons rather than typed by hand
					function()
						local ok, devicons = pcall(require, "nvim-web-devicons")
						if not ok then
							return ""
						end
						local icon = devicons.get_icon(vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = true })
						return icon or ""
					end,
					color = function()
						local ok, devicons = pcall(require, "nvim-web-devicons")
						if not ok then
							return
						end
						local _, color =
							devicons.get_icon_color(vim.fn.expand("%:t"), vim.fn.expand("%:e"), { default = true })
						return { fg = color }
					end,
				},
				{ "filename", path = 1 },
				{
					"diff",
					source = function()
						local s = vim.b.minidiff_summary
						if s then
							return { added = s.add, modified = s.change, removed = s.delete }
						end
					end,
				},
			},
			lualine_x = {
				{
					"diagnostics",
					symbols = { error = " ", warn = " ", info = " ", hint = " " },
				},
				"encoding",
				{ "filetype", icon_only = false }, -- icons_enabled is on by default already
			},
			lualine_y = { "searchcount", "progress" },
			lualine_z = { "location" },
		},
	},
}
