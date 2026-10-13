return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false, -- this plugin doesn't support lazy-loading
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({ "java", "xml", "python", "c", "bash" })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "java", "xml", "python", "c", "sh" },
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})
	end,
}
