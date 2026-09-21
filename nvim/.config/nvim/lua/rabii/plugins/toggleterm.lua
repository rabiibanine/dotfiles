local function read(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local s = f:read("*a")
	f:close()
	return vim.trim(s)
end

-- "dirname" or "dirname · program" when something is running on top of the shell
local function label(term)
	if not term.bufnr or not vim.api.nvim_buf_is_valid(term.bufnr) then
		return
	end
	local pid = vim.b[term.bufnr].terminal_job_pid
	if not pid then
		return
	end
	local cwd = vim.uv.fs_readlink("/proc/" .. pid .. "/cwd")
	local name = cwd and vim.fs.basename(cwd) or "term"
	local child = (read("/proc/" .. pid .. "/task/" .. pid .. "/children") or ""):match("%d+")
	local prog = child and read("/proc/" .. child .. "/comm")
	return prog and (name .. " · " .. prog) or name
end

local function term_select()
	for _, t in ipairs(require("toggleterm.terminal").get_all()) do
		t.display_name = label(t) or t.display_name
	end
	vim.cmd("TermSelect")
end

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	cmd = "ToggleTerm",
	keys = {
		{ "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal", mode = { "n", "t" } },
		{ "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
		{ "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
		{ "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Vertical terminal" },
		{ "<leader>ts", term_select, desc = "Select terminal" },
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
