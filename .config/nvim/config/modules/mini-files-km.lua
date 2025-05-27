-- Copied from https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/modules/mini-files-km.lua

local M = {}

M.setup = function(opts)
  -- Create an autocmd to set buffer-local mappings when a `mini.files` buffer is opened
  -- I use this to open the highlighted directory in a tmux pane on the right
  -- I call the `tmux_pane_functiontmux_pane_function` I defined in my
  -- keympaps.lua file
  vim.api.nvim_create_autocmd("User", {
    -- Updated pattern to match what Echasnovski has in the documentation
    -- https://github.com/echasnovski/mini.nvim/blob/c6eede272cfdb9b804e40dc43bb9bff53f38ed8a/doc/mini-files.txt#L508-L529
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Import 'mini.files' module
      local mini_files = require("mini.files")
      -- Ensure opts.custom_keymaps exists
      local keymaps = opts.custom_keymaps or {}

      -- Copy the current file or directory to the lamw25wmal system clipboard
      -- NOTE: This works only on macOS
      vim.keymap.set("n", keymaps.copy_to_clipboard, function()
        -- Get the current entry (file or directory)
        local curr_entry = mini_files.get_fs_entry()
        if curr_entry then
          local path = curr_entry.path
          -- Escape the path for shell command
          local escaped_path = vim.fn.fnameescape(path)
          -- Build the osascript command to copy the file or directory to the clipboard
          local cmd = string.format([[osascript -e 'set the clipboard to POSIX file "%s"' ]], escaped_path)
          local result = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("Copy failed: " .. result, vim.log.levels.ERROR)
          else
            vim.notify(vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
            vim.notify("Copied to system clipboard", vim.log.levels.INFO)
          end
        else
          vim.notify("No file or directory selected", vim.log.levels.WARN)
        end
      end, { buffer = buf_id, noremap = true, silent = true, desc = "Copy file/directory to clipboard" })

      -- Yank in register relative path of entry under cursor
      vim.keymap.set("n", keymaps.yank_path, function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        if path == nil then
          return vim.notify("Cursor is not on valid entry")
        end

        local home_dir = vim.fn.expand("~")
        local relative_path = path:gsub("^" .. home_dir, "~")
        vim.fn.setreg(vim.v.register, relative_path)
        vim.notify("Yanked " .. relative_path)
      end, { buffer = buf_id, desc = "Yank path" })

      -- Yank path of file relative to pacakges path if exists
      vim.keymap.set("n", keymaps.yank_platform_path, function()
        local path = (MiniFiles.get_fs_entry() or {}).path
        local packages_index = string.find(path, "packages")

        if path == nil or packages_index == nil then
          return vim.notify("Cursor is not on valid entry")
        end

        local packages_path = string.sub(path, packages_index, string.len(path))
        vim.fn.setreg(vim.v.register, packages_path)
      end, { buffer = buf_id, desc = "Yank path relative to packages path" })

      -- Paste the current file or directory from the system clipboard into the current directory in mini.files
      -- NOTE: This works only on macOS
      vim.keymap.set("n", keymaps.paste_from_clipboard, function()
        -- vim.notify("Starting the paste operation...", vim.log.levels.INFO)
        if not mini_files then
          vim.notify("mini.files module not loaded.", vim.log.levels.ERROR)
          return
        end
        local curr_entry = mini_files.get_fs_entry() -- Get the current file system entry
        if not curr_entry then
          vim.notify("Failed to retrieve current entry in mini.files.", vim.log.levels.ERROR)
          return
        end
        local curr_dir = curr_entry.fs_type == "directory" and curr_entry.path
          or vim.fn.fnamemodify(curr_entry.path, ":h") -- Use parent directory if entry is a file
        -- vim.notify("Current directory: " .. curr_dir, vim.log.levels.INFO)
        local script = [[
            tell application "System Events"
              try
                set theFile to the clipboard as alias
                set posixPath to POSIX path of theFile
                return posixPath
              on error
                return "error"
              end try
            end tell
          ]]
        local output = vim.fn.system("osascript -e " .. vim.fn.shellescape(script)) -- Execute AppleScript command
        if vim.v.shell_error ~= 0 or output:find("error") then
          vim.notify("Clipboard does not contain a valid file or directory.", vim.log.levels.WARN)
          return
        end
        local source_path = output:gsub("%s+$", "") -- Trim whitespace from clipboard output
        if source_path == "" then
          vim.notify("Clipboard is empty or invalid.", vim.log.levels.WARN)
          return
        end
        local dest_path = curr_dir .. "/" .. vim.fn.fnamemodify(source_path, ":t") -- Destination path in current directory
        local copy_cmd = vim.fn.isdirectory(source_path) == 1 and { "cp", "-R", source_path, dest_path }
          or { "cp", source_path, dest_path } -- Construct copy command
        local result = vim.fn.system(copy_cmd) -- Execute the copy command
        if vim.v.shell_error ~= 0 then
          vim.notify("Paste operation failed: " .. result, vim.log.levels.ERROR)
          return
        end
        -- vim.notify("Pasted " .. source_path .. " to " .. dest_path, vim.log.levels.INFO)
        mini_files.synchronize() -- Refresh mini.files to show updated directory content
        vim.notify("Pasted successfully.", vim.log.levels.INFO)
      end, { buffer = buf_id, noremap = true, silent = true, desc = "Paste from clipboard" })

      -- Copy the current file or directory path (relative to home) to clipboard
      vim.keymap.set("n", keymaps.copy_path, function()
        -- Get the current entry (file or directory)
        local curr_entry = mini_files.get_fs_entry()
        if curr_entry then
          -- Convert path to be relative to home directory
          local home_dir = vim.fn.expand("~")
          local relative_path = curr_entry.path:gsub("^" .. home_dir, "~")
          vim.fn.setreg("+", relative_path) -- Copy the relative path to the clipboard register
          vim.notify(vim.fn.fnamemodify(relative_path, ":t"), vim.log.levels.INFO)
          vim.notify("Path copied to clipboard: ", vim.log.levels.INFO)
        else
          vim.notify("No file or directory selected", vim.log.levels.WARN)
        end
      end, { buffer = buf_id, noremap = true, silent = true, desc = "Copy relative path to clipboard" })

      -- Preview the selected image in macOS Quick Look
      --
      -- NOTE: This is for macOS, to preview in a neovim popup see below
      --
      -- This wonderful Idea was suggested by @iduran in my youtube video:
      -- https://youtu.be/BzblG2eV8dU
      --
      -- Don't use "i" as it conflicts wit "insert"
      vim.keymap.set("n", keymaps.preview_image, function()
        local curr_entry = mini_files.get_fs_entry()
        if curr_entry then
          -- Preview the file using Quick Look
          vim.system({ "qlmanage", "-p", curr_entry.path }, {
            stdout = false,
            stderr = false,
          })
          -- Activate Quick Look window after a small delay
          vim.defer_fn(function()
            vim.system({ "osascript", "-e", 'tell application "qlmanage" to activate' })
          end, 200)
        else
          vim.notify("No file selected", vim.log.levels.WARN)
        end
      end, { buffer = buf_id, noremap = true, silent = true, desc = "Preview with macOS Quick Look" })
      -- End of keymaps
    end,
  })
end

return M
