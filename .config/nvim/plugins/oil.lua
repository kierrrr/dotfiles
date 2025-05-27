return {
  "stevearc/oil.nvim",
  opts = {
    win_options = {
      wrap = true,
      winbar = "%{v:lua.require('oil').get_current_dir()}",
    },
    delete_to_trash = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = false,
    },
    columns = {
      "icon",
      "size",
    },
  },
  keys = {
    {
      "<leader>o",
      "<cmd>Oil --preview<cr>",
      desc = "Oil",
    },
  },
}
