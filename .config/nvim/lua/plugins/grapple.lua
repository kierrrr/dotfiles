return {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	keys = function()
		local keys = {
			{
				"<leader>a",
				function()
					require("grapple").tag()
					-- require("grapple").tag({ path = "<cfile>" })
				end,
				desc = "Tag a file",
			},
			{ "<leader>hi", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },
		}

		for i = 1, 9 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					require("grapple").select({ index = i })
				end,
				desc = "Grapple to file " .. i,
			})
		end
		return keys
	end,
}
