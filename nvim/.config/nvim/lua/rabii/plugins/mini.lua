return {
	{
		"nvim-mini/mini.ai",
		event = "VeryLazy",
		opts = {}, -- better a/i textobjects: af/if (function), ac/ic (class), etc.
	},
	{
		"nvim-mini/mini.surround",
		event = "VeryLazy",
		opts = {}, -- sa = add, sd = delete, sr = replace, sf/sF = find, sh = highlight
	},
	{
		"nvim-mini/mini.pairs",
		event = "InsertEnter",
		opts = {}, -- auto-closes (), [], {}, "", ''
	},
	{
		"nvim-mini/mini.diff",
		event = "VeryLazy",
		opts = { view = { style = "sign", signs = { add = "", change = "", delete = "" } } },
	},
	{
		"nvim-mini/mini.hipatterns",
		event = "VeryLazy",
		opts = {}, -- gcc toggles the current line, gc is the operator (e.g. gcip)
	},
}
