local mini_files_km = require("config.modules.mini-files-km")

return {
  "nvim-mini/mini.files",
  enabled = true,
  lazy = false, -- Overrides Snacks.explorer from displaying
  opts = function(_, opts)
    -- I didn't like the default mappings, so I modified them
    opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, {
      close = "<esc>",
      go_in = "l",
      go_out = "H", -- Default L
      go_out_plus = "h",
      reset = "<BS>",
      reveal_cwd = ".", -- Default @
      show_help = "g?",

      synchronize = "s", -- Default =
      trim_left = "<",
      trim_right = ">",
    })

    opts.custom_keymaps = {
      copy_to_clipboard = "<leader>yy",
      paste_from_clipboard = "<leader>p",
      copy_path = "<M-c>",
      -- Don't use "i" as it conflicts wit insert mode
      preview_image = "<leader>i",
      -- preview_image_popup = "<M-i>", -- doesn't work
      yank_path = "<leader>gy",
      yank_platform_path = "<leader>yp",
    }

    opts.windows = vim.tbl_deep_extend("force", opts.windows or {}, {
      preview = true,
      width_nofocus = 25,
      width_focus = 40,
      width_preview = 70,
    })

    opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
      -- Whether to use for editing directories
      -- Disabled by default in LazyVim because neo-tree is used for that
      use_as_default_explorer = true,
      -- If set to false, files are moved to the trash directory
      -- To get this dir run :echo stdpath('data')
      -- ~/.local/share/neobean/mini.files/trash
      permanent_delete = false,
    })
    return opts
  end,
  config = function(_, opts)
    -- Set up mini.files
    require("mini.files").setup(opts)
    -- Load custom keymaps
    mini_files_km.setup(opts)

    -- -- Load Git integration
    -- -- git config is slowing mini.files too much, so disabling it
    -- mini_files_git.setup()
  end,
  keys = {
    {
      "<leader>e",
      function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        if vim.fn.filereadable(buf_name) == 1 then
          local dir_name = vim.fn.fnamemodify(buf_name, ":p:h")
          -- Pass the full file path to highlight the file
          require("mini.files").open(buf_name, true)
        elseif vim.fn.isdirectory(dir_name) == 1 then
          -- If the directory exists but the file doesn't, open the directory
          require("mini.files").open(dir_name, true)
        else
          -- If neither exists, fallback to the current working directory
          require("mini.files").open(vim.uv.cwd(), true)
        end
      end,
      desc = "Open mini.files (Dir)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (CWD)",
    },
  },
}
