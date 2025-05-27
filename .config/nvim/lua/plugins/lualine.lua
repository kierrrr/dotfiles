return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- table.insert(opts.sections.lualine_c, {
    --   "filename",
    --   file_status = true, -- displays file status (readonly status, modified status)
    --   path = 2, -- 0 = just filename, 1 = relative path, 2 = absolute path
    -- })
  end,
}
