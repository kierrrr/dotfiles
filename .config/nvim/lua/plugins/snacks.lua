return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		---@class snacks.scroll.Config
		---@field animate snacks.animate.Config
		scroll = {
			-- your scroll configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			enabled = false,
			animate = {
				duration = { step = 95, total = 100 },
				easing = "outCubic",
			},
			spamming = 10, -- threshold for spamming detection
			-- what buffers to animate
			filter = function(buf)
				return vim.g.snacks_scroll ~= false
					and vim.b[buf].snacks_scroll ~= false
					and vim.bo[buf].buftype ~= "terminal"
			end,
		},
		image = {
			enabled = true,
		},
		picker = {
			enabled = true,
			file = {
				truncate = 100,
			},
			previewers = {
				-- diff = {
				--   builtin = false, -- use Neovim for previewing diffs (true) or use an external tool (false)
				--   cmd = { "delta" }, -- example to show a diff with delta
				-- },
				git = {
					builtin = true, -- use Neovim for previewing git output (true) or use git (false)
					args = {}, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
				},
			},
		},
	},
	keys = {
		{
			"<leader><space>",
			function()
				Snacks.picker.smart({ cwd = vim.uv.cwd() })
			end,
			desc = "Smart Find Files (cwd)",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep({ cwd = vim.uv.cwd() })
			end,
			desc = "Grep (cwd)",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status({
					cwd = vim.uv.cwd(), -- Not working
				})
			end,
			desc = "Git status (cwd)",
		},
	},
}
