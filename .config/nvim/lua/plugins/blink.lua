return {
	"Saghen/blink.cmp",
	enable = true,
	build = "cargo build --release",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		completion = {
			menu = {
				border = "rounded",
				draw = {
					padding = 1,
					gap = 1,
					columns = { { "kind_icon" }, { "label", "label_description", "source_name", gap = 1 } },
				},
			},
			documentation = { window = { border = "rounded" } },
		},
		signature = { window = { border = "rounded" } },
	},
}
