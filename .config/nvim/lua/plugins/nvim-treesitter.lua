return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-n>", -- set to `false` to disable one of the mappings
        node_incremental = "<C-n>",
        node_decremental = "<C-p>",
      },
    },
  },
}
