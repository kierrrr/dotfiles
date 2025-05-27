return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            -- workingDirectories = { mode = "auto" },
            -- format = auto_format,
          },
        },
      },
    },
    keys = {
      {
        "<leader>ce",
        function()
          local nvim_lsp = require("lspconfig.util")
          -- This doesn't work because Atlassian has some eslint adapter that uses the relative directory of the file
          -- Not sure if it works on VSCode
          -- require("lspconfig").eslint.setup({
          --   settings = {
          --     workingDirectory = { mode = "location" },
          --   },
          --   root_dir = function(fname)
          --     local confluence_platform_dir = nvim_lsp.root_pattern(".git")(fname)
          --     return confluence_platform_dir .. "/confluence/platform"
          --   end,
          --
          -- local confluence_platform_dir = nvim_lsp.root_pattern(".git")(fname)
          -- return confluence_platform_dir .. "/confluence/platform"

          -- This doesn't fix eslint issues but it makes Noice not throw errors all the time
          require("lspconfig").eslint.setup({
            settings = {
              workingDirectory = { mode = "location" },
            },
            root_dir = nvim_lsp.find_git_ancestor,
          })

          -- require("lspconfig").eslint.setup({
          --   settings = {
          --     -- packageManager = "yarn",
          --     -- workingDirectory = "../confluence/platform",
          --     -- workingDirectory = { mode = "auto" },
          --     -- nodePath = "confluence/node_modules",
          --     -- workingDirectory = "/node_modules",
          --     -- nodePath = "/node_modules",
          --   },
          --
          --   -- root_dir = nvim_lsp.find_git_ancestor,
          --   root_dir = function(fname)
          --     local confluence_platform_dir = nvim_lsp.root_pattern(".git")(fname)
          --     return confluence_platform_dir .. "/confluence/platform"
          --   end,
          -- })
        end,
        desc = "Change eslint root_dir to .git directory",
      },
    },
  },
}
