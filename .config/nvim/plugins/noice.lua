return {
  "folke/noice.nvim",
  -- lazy = false,
  opts = {
    -- lsp = {
    -- 	override = {
    -- 		["vim.lsp.util.convert_input_to_markdown_lines"] = true,
    -- 		["vim.lsp.util.stylize_markdown"] = true,
    -- 		["cmp.entry.get_documentation"] = true,
    -- 	},
    -- },
    -- routes = {
    -- 	{
    -- 		filter = {
    -- 			event = "msg_show",
    -- 			any = {
    -- 				{ find = "%d+L, %d+B" },
    -- 				{ find = "; after #%d+" },
    -- 				{ find = "; before #%d+" },
    -- 			},
    -- 		},
    -- 		view = "mini",
    -- 	},
    -- 	{
    -- 		filter = {
    -- 			event = "notify",
    -- 			find = "No information available",
    -- 		},
    -- 		opts = {
    -- 			skip = true,
    -- 		},
    -- 	},
    -- },
    -- popupmenu = {
    --   backend = "cmp",
    -- },
    presets = {
      -- bottom_search = true,
      -- command_palette = true,
      -- long_message_to_split = true,
      -- inc_rename = true,
      lsp_doc_border = true, -- Do not remove this or else you lose LSP text hover border
    },
  },
}
