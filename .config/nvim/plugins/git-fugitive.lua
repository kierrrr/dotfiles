return {
  "tpope/vim-fugitive",
  lazy = false,
  keys = {
    {
      "<leader>gd",
      "<cmd>Gvdiffsplit!<CR>",
      desc = "Show merge conflict diff",
    },
    {
      "<leader>gdh",
      "<cmd>diffget //2<CR>",
      desc = "Pick left diff",
    },
    {
      "<leader>gdl",
      "<cmd>diffget //3<CR>",
      desc = "Pick right diff",
    },
  },
}
