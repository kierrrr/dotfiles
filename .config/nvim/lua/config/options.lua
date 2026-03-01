-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- Disable relative number lines
vim.opt.relativenumber = false

-- Spell checker
vim.opt.spelllang = "en_au"

vim.opt.clipboard = "unnamedplus"

-- Disbale swapfiles
vim.opt.swapfile = false

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = false

-- This is required to add borders around code diagnostics such as eslint warnings
vim.diagnostic.config({
	float = {
		border = "rounded",
	},
})

-- Don't know where this can be used again. folke/noice.nvim adds the borders
-- local border = {
--   { "┌", "FloatBorder" },
--   { "─", "FloatBorder" },
--   { "┐", "FloatBorder" },
--   { "│", "FloatBorder" },
--   { "┘", "FloatBorder" },
--   { "─", "FloatBorder" },
--   { "└", "FloatBorder" },
--   { "│", "FloatBorder" },
-- }

-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })

-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
