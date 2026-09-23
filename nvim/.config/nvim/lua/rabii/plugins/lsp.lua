return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
			"saghen/blink.lib",
		},
		opts = {
			ensure_installed = {
				"lua_ls", -- editing this config itself
				"basedpyright", -- python
				"ruff", -- python (linting + formatting, via its native LSP mode)
				"vtsls", -- typescript/javascript
				"html",
				"cssls",
				"jsonls",
				"eslint",
				"clangd", -- c and c++
				"marksman",
			},
			automatic_enable = true,
		},
		config = function(_, opts)
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
					},
				},
			})

			-- ruff handles linting; basedpyright handles types/hover/go-to-def.
			-- Running both is the standard pairing — disable ruff's hover so it
			-- doesn't fight basedpyright's.
			vim.lsp.config("ruff", {
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			})

			vim.lsp.config("basedpyright", {
				settings = {
					basedpyright = {
						analysis = {
							diagnosticSeverityOverrides = {
								reportUnknownParameterType = "none",
								reportMissingParameterType = "none",
								reportUnknownLambdaType = "none",
							},
						},
					},
				},
			})

			require("mason-lspconfig").setup(opts)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("rabii_lsp_attach", { clear = true }),
				callback = function(event)
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
					end
					map("n", "gd", vim.lsp.buf.definition, "Goto definition")
					map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
					map("n", "gr", vim.lsp.buf.references, "Goto references")
					map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
					map("n", "K", vim.lsp.buf.hover, "Hover documentation")
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
					map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
				end,
			})

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				severity_sort = true,
			})
		end,
	},
}
