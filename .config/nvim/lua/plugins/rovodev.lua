return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    adapters = {
      acp = {
        rovodev = function()
          local helpers = require("codecompanion.adapters.acp.helpers")
          return {
            name = "rovodev",
            type = "acp",
            formatted_name = "RovoDev",
            roles = {
              llm = "assistant",
              user = "user",
            },
            opts = {
              verbose_output = true,
            },
            commands = {
              default = {
                "acli",
                "rovodev",
                "acp",
              },
            },
            defaults = {},
            parameters = {
              protocolVersion = 1,
              clientCapabilities = {
                fs = { readTextFile = true, writeTextFile = true },
              },
              clientInfo = {
                name = "CodeCompanion.nvim",
                version = "1.0.0",
              },
            },
            handlers = {
              setup = function(self)
                return true
              end,
              form_messages = function(self, messages, capabilities)
                return helpers.form_messages(self, messages, capabilities)
              end,
              on_exit = function(self, code) end,
            },
          }
        end,
      },
    },
    strategies = {
      chat = {
        adapter = "rovodev",
      },
      inline = {
        adapter = "rovodev",
      },
      cmd = {
        adapter = "rovodev",
      },
    },
    opts = {
      log_level = "DEBUG",
    },
  },
  prompt_library = {
    markdown = {
      dirs = {
        "~/.config/prompts",
      },
    },
  },
}
