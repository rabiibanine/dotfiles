return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	dependencies = { "williamboman/mason.nvim" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			desc = "Format buffer",
		},
	},
	init = function()
		-- installs the formatter binaries themselves (ruff is already pulled
		-- in as an LSP server above, no need to duplicate it here)
		require("mason-tool-installer").setup({
			ensure_installed = { "stylua", "prettierd", "clang-format" },
		})
	end,
	dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format" }, -- fix lint issues, then format
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			html = { "prettierd" },
			css = { "prettierd" },
			json = { "prettierd" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
		format_on_save = { timeout_ms = 500, lsp_fallback = true },
	},
}
