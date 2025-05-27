return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "thenbe/neotest-playwright",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          }),
        },
        consumers = {
          playwright = require("neotest-playwright.consumers").consumers,
        },
      })
    end,
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").playwright.attachment()
        end,
        desc = "Launch test attachment",
      },
    },
  },
}
