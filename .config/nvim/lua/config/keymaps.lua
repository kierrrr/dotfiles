-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Page up/down and move the page to the middle
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- When moving jump lists, move the page to the middle
keymap.set("n", "<C-i>", "<C-i>zz")
keymap.set("n", "<C-o>", "<C-o>zz")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Another Escape Key
-- keymap.set("i", "<C-c>", "<Esc>", opts)

-- Map Copy and Paste from Clipboard
keymap.set("n", "<leader>p", "'+p'")

-- Yank into system clipboard
keymap.set({ "n", "v" }, "<leader>y", '"+y') -- yank motion
keymap.set({ "n", "v" }, "<leader>Y", '"+Y') -- yank line

-- Delete into system clipboard
keymap.set({ "n", "v" }, "<leader>d", '"+d') -- delete motion
keymap.set({ "n", "v" }, "<leader>D", '"+D') -- delete line

-- Paste from system clipboard
-- keymap.set("n", "<leader>p", '"+p') -- paste after cursor
-- keymap.set("n", "<leader>P", '"+P') -- paste before cursor

-- Pasting should NOT add the values pasted over to the register
-- keymap.set("x", "p", "P")

-- Next and previous and centre on page
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Escape when commenting code
-- keymap.set({ "n", "v" }, "<leader>gcc", "<leader>gcc<esc>")

-- Move selection
keymap.set({ "n", "v" }, "<M-J>", ":m '>+1<Return>gv=gv", opts) -- shift + alt + j
keymap.set({ "n", "v" }, "<M-K>", ":m '<-2<Return>gv=gv", opts) -- shift + alt + k

-- Insert mode arrow keys
keymap.set({ "i" }, "<M-h>", "<Left>") -- h
keymap.set({ "i" }, "<M-j>", "<Down>") -- j
keymap.set({ "i" }, "<M-k>", "<Up>") -- k
keymap.set({ "i" }, "<M-l>", "<Right>") -- l
