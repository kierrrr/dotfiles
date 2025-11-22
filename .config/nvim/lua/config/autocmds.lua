-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.notify("this is from autocmd")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc" },
	callback = function()
		vim.wo.spell = false
		vim.wo.conceallevel = 0
	end,
})

-- Set GraphQL LSP for Nadel files - Atlassian derived GraphQL schemas
vim.api.nvim_create_autocmd({ "BufReadPost", "BufRead", "BufNewFile" }, {
	pattern = "*.nadel",
	command = "set filetype=graphql",
})

-- vim.api.nvim_create_user_command("RunTSCQuickfix", function()
--   local cmd = "z platform && yarn typecheck:package packages/search/search-page"
--   local output = vim.fn.systemlist(cmd)
--
--   for k, v in pairs(table) do
--     print(k)
--   end
--
--   -- Process the output to format it for quickfix list
--   local filtered_output = {}
--   for _, line in ipairs(output) do
--     if line:match("^||") then
--       line = line:gsub("^||%s*", "")
--     end
--     if line:match("src/.*%.ts%(") then
--       -- Extract filename, line, col and message
--       local filename, line_num, col_num, message = line:match("(.*)%((%d+),(%d+)%)%: (.*)")
--       if filename and line_num and col_num and message then
--         table.insert(filtered_output, filename .. ":" .. line_num .. ":" .. col_num .. ":" .. message)
--       end
--     end
--   end
--
--   if #filtered_output == 0 then
--     print("No TypeScript errors")
--   else
--     vim.fn.setqflist({}, "r", { title = "tsc", lines = filtered_output })
--     vim.cmd("Trouble toggle quickfix")
--   end
-- end, {})
