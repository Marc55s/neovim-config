require("core.remap")
require("core.set")
require("core.lazy_init")


local autocmd = vim.api.nvim_create_autocmd


autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.conceallevel = 1
    end,
})

autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.api.nvim_create_autocmd("TextYankPost", {
        desc = "Highlight when yanking (copying) text",
        group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
        callback = function()
                vim.highlight.on_yank()
        end,
})


-- Function to recursively find all C files and compile them with Zig
function CompileAndRunC()
    -- Save all current files
    vim.cmd("wa")
    
    -- Get the directory of the current file
    local current_file = vim.fn.expand("%:p")
    local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

    -- Extract the directory name to use as the executable name
    local dir_name = vim.fn.fnamemodify(current_dir, ":t")
    local output_file = current_dir .. "/" .. dir_name .. ".exe"

    -- Detect system path separator (use "\\" for Windows)
    local path_sep = package.config:sub(1,1)  -- This returns "\\" on Windows and "/" on Unix-based systems

    -- Function to recursively collect all .c files, ignoring .git directory
    local function find_c_files(dir)
        local c_files = {}

        -- Helper function to scan the directory
        local function scan_dir(directory)
            local entries = vim.fn.readdir(directory)
            for _, entry in ipairs(entries) do
                local full_path = directory .. path_sep .. entry  -- Use appropriate path separator
                if entry ~= ".git" then  -- Ignore .git directory
                    if vim.fn.isdirectory(full_path) == 1 then
                        -- Recursively scan subdirectories
                        scan_dir(full_path)
                    elseif entry:match("%.c$") then
                        table.insert(c_files, full_path)
                    end
                end
            end
        end

        scan_dir(dir)
        return c_files
    end

    -- Collect all .c files recursively starting from the current directory
    local c_files = find_c_files(current_dir)

    if #c_files == 0 then
        print("No C files found.")
        return
    end

    -- Join all .c files into a single line, space-separated
    local c_files_str = table.concat(c_files, " ")

    -- Create the compile command by placing input files before the '-o' flag
    local compile_command = "zig cc " .. c_files_str .. " -o " .. output_file

    -- Print the command for debugging
    print("Compile command: " .. compile_command)

    -- Run the compilation command
    local compile_status = vim.fn.system(compile_command)

    -- Print the compile output for debugging
    print("Compile output: " .. compile_status)

    -- Check if compilation was successful
    if vim.fn.filereadable(output_file) == 1 then
        -- Run the executable
        vim.cmd("!" .. output_file)
    else
        print("Compilation failed.")
        print(compile_status)  -- Print the error message from the compilation
    end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.opt_local.wrap = false
  end,
})

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local obsidian_functions = {
    { name = "Tags", cmd = ":ObsidianTags" },
    { name = "TOC", cmd = ":ObsidianTOC" },
    { name = "Extract Note", cmd = ":ObsidianExtractNote" },
    { name = "Debug", cmd = ":ObsidianDebug" },
    { name = "Dailies", cmd = ":ObsidianDailies" },
    { name = "Check", cmd = ":ObsidianCheck" },
    { name = "Backlinks", cmd = ":ObsidianBacklinks" },
    { name = "New Note", cmd = ":ObsidianNew" },
    { name = "Search Notes", cmd = ":ObsidianSearch" },
    { name = "Quick Switch", cmd = ":ObsidianQuickSwitch" },
    { name = "Open Today’s Note", cmd = ":ObsidianToday" },
    { name = "Backlinks", cmd = ":ObsidianBacklinks" },
    { name = "Open URL", cmd = ":ObsidianOpen" },
    { name = "Template", cmd = ":ObsidianTemplate" },
    { name = "New From Template", cmd = ":ObsidianNewFromTemplate" },
    { name = "Rename", cmd = ":ObsidianRename" },
    { name = "Links", cmd = ":ObsidianLinks" },
    { name = "Link", cmd = ":ObsidianLink" },
    { name = "Follow Link", cmd = ":ObsidianFollowLink" },
}

function open_obsidian_function()
    require("telescope.pickers").new({}, {
        prompt_title = "Obsidian Functions",
        finder = require("telescope.finders").new_table({
            results = obsidian_functions,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(_, map)
            map("i", "<CR>", function(bufnr)
                local selection = action_state.get_selected_entry(bufnr)
                actions.close(bufnr)
                vim.cmd(selection.value.cmd)
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_set_keymap(
    "n",
    "<leader>oo",
    "<cmd>lua open_obsidian_function()<CR>",
    { noremap = true, silent = true }
)

