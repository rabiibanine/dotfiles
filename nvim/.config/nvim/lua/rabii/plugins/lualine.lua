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
			lualine_b = { "branch" },
			lualine_c = {
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
			lualine_x = { "diagnostics", "encoding", "filetype" },
			lualine_y = { "searchcount", "progress" },
			lualine_z = { "location" },
		},
	},
}
