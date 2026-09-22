return {
	{
		"nvim-mini/mini.ai",
		event = "VeryLazy",
		opts = {}, -- better a/i textobjects: af/if (function), ac/ic (class), etc.
		config = function(_, opts)
			require("mini.ai").setup(opts)
		end,
	},
	{
		"nvim-mini/mini.surround",
		event = "VeryLazy",
		opts = {}, -- sa = add, sd = delete, sr = replace, sf/sF = find, sh = highlight
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},
	{
		"nvim-mini/mini.pairs",
		event = "InsertEnter",
		opts = {}, -- auto-closes (), [], {}, "", ''
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},
	{
		"nvim-mini/mini.diff",
		event = "VeryLazy",
		opts = {
			view = { style = "sign" }, -- force sign-column marks instead of colored line numbers
		},
		config = function(_, opts)
			require("mini.diff").setup(opts)
		end,
	},
	{
		"nvim-mini/mini.hipatterns",
		event = "VeryLazy",
		opts = {}, -- gcc toggles the current line, gc is the operator (e.g. gcip)
		config = function(_, opts)
			require("mini.hipatterns").setup(opts)
		end,
	},
}
