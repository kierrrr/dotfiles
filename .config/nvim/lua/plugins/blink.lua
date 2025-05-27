return {
  "saghen/blink.cmp",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
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
      list = {
        selection = function(ctx)
          return ctx.mode == "cmdline" and "auto_insert" or "preselect"
        end,
      },
    },
    signature = { window = { border = "rounded" } },
    sources = {
      cmdline = function()
        local type = vim.fn.getcmdtype()
        -- Search forward and backward
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        -- Commands
        if type == ":" then
          return { "cmdline" }
        end
        return {}
      end,
    },
  },
}
