return {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = "~/vaults/study",
            },
        },
        completion = {
            -- Enable completion with nvim-cmp.
            nvim_cmp = true,
            -- Trigger completion at 2 chars.
            min_chars = 2,
        },

        ui = {
            enable = true
        },

        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = "daily",
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = "%Y-%m-%d",
            -- Optional, if you want to change the date format of the default alias of daily notes.
            alias_format = "%B %-d, %Y",
            -- Optional, default tags to add to each new daily note created.
            default_tags = { "daily-notes" },
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = nil
        },

        picker = {
            -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
            name = "telescope.nvim",
            -- Optional, configure key mappings for the picker. These are the defaults.
            -- Not all pickers support all mappings.
            note_mappings = {
                -- Create a new note from your query.
                new = "<C-x>",
                -- Insert a link to the selected note.
                insert_link = "<C-l>",
            },
            tag_mappings = {
                -- Add tag(s) to current note.
                tag_note = "<C-x>",
                -- Insert a tag at the current location.
                insert_tag = "<C-l>",
            },
        },

        disable_frontmatter = true,  -- Disable metadata frontmatter
        note_id_func = function(title)
        -- Use the title as the filename instead of generating an ID
            return title:gsub(" ", "_"):lower()
        end,
        mappings = {
            -- Smart action depending on context, either follow link or toggle checkbox.
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            },
            -- Create a new note.
            ["<leader>on"] = {
                action = ":ObsidianNew<CR>",
                opts = { noremap = true, silent = true, desc = "Create a new note" },
            },
            -- Rename the current note.
            ["<leader>or"] = {
                action = ":ObsidianRename<CR>",
                opts = { noremap = true, silent = true, desc = "Rename current note" },
            },
            -- Open the Obsidian search.
            ["<leader>og"] = {
                action = ":ObsidianSearch<CR>",
                opts = { noremap = true, silent = true, desc = "Search notes" },
            },
            -- Quickly switch to another note.
            ["<leader>of"] = {
                action = ":ObsidianQuickSwitch<CR>",
                opts = { noremap = true, silent = true, desc = "Quick switch notes" },
            },
            -- Open today's daily note.
            ["<leader>od"] = {
                action = ":ObsidianToday<CR>",
                opts = { noremap = true, silent = true, desc = "Open today's note" },
            },
            -- Open yesterday's daily note.
            ["<leader>oy"] = {
                action = ":ObsidianYesterday<CR>",
                opts = { noremap = true, silent = true, desc = "Open yesterday's note" },
            },
            -- Open the Obsidian backlinks picker.
            ["<leader>ob"] = {
                action = ":ObsidianBacklinks<CR>",
                opts = { noremap = true, silent = true, desc = "View backlinks" },
            },
            -- Insert a template into the note.
            ["<leader>ot"] = {
                action = ":ObsidianTemplate<CR>",
                opts = { noremap = true, silent = true, desc = "Insert a template" },
            },
            -- Collect all links in the current buffer.
            ["<leader>ol"] = {
                action = ":ObsidianLinks<CR>",
                opts = { noremap = true, silent = true, desc = "Collect all links" },
            },
        },
    },
}
