return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "marilari88/twoslash-queries.nvim" },
	opts = {
		tsserver_max_memory = "auto",
	},
	config = function()
		require("typescript-tools").setup({
			settings = {
				-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
				-- memory limit in megabytes or "auto"(basically no limit)
				tsserver_max_memory = "12000",
				-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
				-- "remove_unused_imports"|"organize_imports") -- or string "all"
				-- to include all supported code actions
				-- specify commands exposed as code_actions
				-- expose_as_code_action = ""fix_all"|"add_missing_imports"|"remove_unused"|
				-- "remove_unused_imports"|"organize_imports"",
			},
			on_attach = function(client, bufnr)
				require("twoslash-queries").attach(client, bufnr)
			end,
		})
	end,
}
