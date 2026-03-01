-- Modification of default configutation
return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = false,
      },
      explorer = {
        enabled = false,
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
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "tsgo",
        "eslint-lsp",
        "prettierd",
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          border = "rounded",
          draw = {
            padding = 1,
            gap = 1,
            columns = { { "kind_icon" }, { "label", "label_description", "source_name", gap = 1 } },
          },
        },
        documentation = { window = { border = "rounded" } },
      },
      signature = { window = { border = "rounded" } },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true, -- Adds LSP text hover border
      },
    },
  },
}
