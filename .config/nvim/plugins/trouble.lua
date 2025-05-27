return {
  "folke/trouble.nvim",
  -- opts will be merged with the parent spec
  -----@class trouble.Mode: trouble.Config,trouble.Section.spec
  ---@field desc? string
  ---@field sections? string[]

  ---@class trouble.Config
  ---@field mode? string
  ---@field config? fun(opts:trouble.Config)
  ---@field formatters? table<string,trouble.Formatter> custom formatters
  ---@field filters? table<string, trouble.FilterFn> custom filters
  ---@field sorters? table<string, trouble.SorterFn> custom sorters
  opts = {
    modes = {
      symbols = {
        focus = true,
        win = {
          position = "left",
          size = 0.3,
        },
        filter = {
          any = {
            kind = {
              "Variable",
              "Constant",
              "Class",
              -- "Constructor",
              "Enum",
              -- "Field",
              "Function",
              "Interface",
              -- "Method",
              "Module",
              "Namespace",
              "Package",
              "Property",
              "Struct",
              "Trait",
            },
          },
        },
      },
    },
  },
}
