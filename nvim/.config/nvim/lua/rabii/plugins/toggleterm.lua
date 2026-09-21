return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = "ToggleTerm",
	keys = {
		{ "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal", mode = { "n", "t" } },
		{ "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
		{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
		{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Vertical terminal" },
	},
	opts = {
		open_mapping = [[<C-\>]],
		direction = "float",
		float_opts = { border = "curved" },
		shading_factor = 2,
		size = function(term)
			if term.direction == "horizontal" then
				return 15
			elseif term.direction == "vertical" then
				return math.floor(vim.o.columns * 0.4)
			end
		end,
	},
	config = function(_, opts)
		require("toggleterm").setup(opts)

		-- Window nav + your jk/kj escape, extended into terminal mode too —
		-- this is exactly the gap that bit you in AstroNvim (jk was insert-only
		-- there). Here it's our config, so we just add it ourselves.
		vim.api.nvim_create_autocmd("TermOpen", {
			group = vim.api.nvim_create_augroup("rabii_toggleterm", { clear = true }),
			pattern = "term://*toggleterm#*",
			callback = function()
				local map_opts = { buffer = 0 }
				vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>", map_opts)
				vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>", map_opts)
				vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>", map_opts)
				vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>", map_opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], map_opts)
				vim.keymap.set("t", "kj", [[<C-\><C-n>]], map_opts)
			end,
		})
	end,
}
