return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        dashboard = {
            enabled = true,
            sections = {
                { section = "header" },
                { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                { section = "startup" },
            },
            preset = {
                header = {
                [[
                                                                       
        ████ ██████           █████      ██                      
       ███████████             █████                              
       █████████ ███████████████████ ███   ███████████    
      █████████  ███    █████████████ █████ ██████████████    
     █████████ ██████████ █████████ █████ █████ ████ █████    
   ███████████ ███    ███ █████████ █████ █████ ████ █████   
  ██████  █████████████████████ ████ █████ █████ ████ ██████  
                                                                           ]]
                },
            },
        },

        image = {
            enabled = true,
            formats = {
                "png",
                "jpg",
                "jpeg",
                "gif",
                "bmp",
                "webp",
                "tiff",
                "heic",
                "avif",
                "mp4",
                "mov",
                "avi",
                "mkv",
                "webm",
                "pdf",
            },
            force = false, -- try displaying the image, even if the terminal does not support it
            doc = {
                -- enable image viewer for documents
                -- a treesitter parser must be available for the enabled languages.
                -- supported language injections: markdown, html
                enabled = true,
                -- render the image inline in the buffer
                -- if your env doesn't support unicode placeholders, this will be disabled
                -- takes precedence over `opts.float` on supported terminals
                inline = true,
                -- render the image in a floating window
                -- only used if `opts.inline` is disabled
                float = true,
                max_width = 80,
                max_height = 40,
            },
            convert = {
                notify = true,           -- show a notification on error
                math = {
                    font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
                    -- for latex documents, the doc packages are included automatically,
                    -- but you can add more packages here. Useful for markdown documents.
                    packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools", "physics", "siunitx", "mhchem" },
                },
            },
            cache = vim.fn.stdpath("cache") .. "/snacks/image",
            debug = {
                request = false,
                convert = false,
                placement = false,
            },
        },
        bigfile = { enabled = true },
        words = { enabled = false },
        statuscolumn = { enabled = true },
        lazygit = { enabled = true },
        --scroll = {enabled = true},
        notifier = { enabled = true },
        picker = { enabled = true,
            opts = {
                explorer = {
                    replace_netrw = true,
                }
            },
            layout = {
                reverse = true,
                layout = {
                    box = "horizontal",
                    backdrop = false,
                    width = 0.8,
                    height = 0.8,
                    border = "none",
                    {
                        box = "vertical",
                        border = "rounded",
                        { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
                        { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
                    },
                    {
                        win = "preview",
                        title = "{preview:Preview}",
                        width = 0.6,
                        border = "rounded",
                        title_pos = "center",
                    },
                },
            }
        },

    },

    keys = {
        -- Lazygit
        { "<leader>lg",      function() Snacks.lazygit() end,             desc = "Lazygit" },

        -- Picker
        { "<leader><space>", function() Snacks.picker.smart() end,        desc = "Smart Find Files" },
        { "<leader>ff",      function() Snacks.picker.files() end,        desc = "Find Files" },
        { "<leader>fb",      function() Snacks.picker.buffers() end,      desc = "Buffers" },
        { "<leader>fg",      function() Snacks.picker.grep() end,         desc = "Grep" },
        { "<leader>fr",      function() Snacks.picker.recent() end,       desc = "Recent" },
        { "<leader>dd",      function() Snacks.picker.git_diff() end,     desc = "Git Diff (Hunks)" },
        { "<leader>tt",      function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },

    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                Snacks.toggle.diagnostics():map("<leader>ud")
                Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uD")
            end,
        })
    end,
}
