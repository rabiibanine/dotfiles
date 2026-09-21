return {
	"saghen/blink.cmp",
	build = function()
		require("blink.cmp").build():wait()
	end,
	version = "2.*", -- prebuilt release, no Rust toolchain needed
	event = "InsertEnter",
	dependencies = { "saghen/blink.lib", "rafamadriz/friendly-snippets" },
	opts = {
		keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> navigate, <C-space> open menu
		appearance = { nerd_font_variant = "mono" },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
			menu = { border = "rounded" },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		signature = { enabled = true },
	},
}
