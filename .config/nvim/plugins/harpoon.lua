return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	opts = {
		settings = {
			save_on_toggle = true,
		},
	},
	keys = function()
		local harpoon = require("harpoon")

		local keys = {
			{
				"<leader>H",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>a",
				function()
					harpoon:list():add()
				end,
				desc = "Harpoon File",
			},
			{
				"<leader>hi",
				function()
					require("harpoon").ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon Quick Menu",
			},
			{
				"<leader>9",
				function()
					harpoon:list():prev({ ui_nav_wrap = true })
				end,
				desc = "Previous Harpoon File",
			},
			{
				"<leader>0",
				function()
					harpoon:list():next({ ui_nav_wrap = true })
				end,
				desc = "Next Harpoon File",
			},
		}

		for i = 1, 5 do
			table.insert(keys, {
				"<leader>" .. i,
				function()
					harpoon:list():select(i)
				end,
				desc = "Harpoon to File " .. i,
			})
		end
		return keys
	end,
}
