return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	branch = "harpoon2",
	opts = {
		settings = {
			save_on_toggle = true,
		},
	},
	keys = function()
		local harpoon = require("harpoon")
		local conf = require("telescope.config").values

		local create_finder = function(harpoon_files)
			local file_paths = {}
			for index, item in ipairs(harpoon_files.items) do
				local file_path_data = {}
				table.insert(file_path_data, index)
				table.insert(file_path_data, item.value)
				table.insert(file_paths, file_path_data)
			end

			return require("telescope.finders").new_table({
				results = file_paths,
				entry_maker = function(entry)
					return {
						value = entry[2],
						display = "[" .. entry[1] .. "] " .. entry[2],
						ordinal = entry[2],
					}
				end,
			})
		end

		local function toggle_telescope(harpoon_files)
			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = create_finder(harpoon_files),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_buffer_number, map)
						map("i", "<m-d>", function()
							local state = require("telescope.actions.state")
							local current_picker = state.get_current_picker(prompt_buffer_number)

							current_picker:delete_selection(function(selection)
								for index, harpoon_item in ipairs(harpoon_files.items) do
									if selection.value == harpoon_item.value then
										table.remove(harpoon_files.items, index)
									end
								end
							end)
						end)
						return true
					end,
				})
				:find()
		end

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
			{
				"<leader>hh",
				function()
					toggle_telescope(harpoon:list())
				end,
				desc = "Telescope harpoon",
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
