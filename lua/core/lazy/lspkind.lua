return {
    "onsails/lspkind.nvim",
    event = "InsertEnter", -- Use InsertEnter to ensure it loads for autocompletion
    config = function()
        require("lspkind").init({
            mode = "symbol_text", -- Show both symbols and text annotations
            preset = "codicons", -- Use VSCode Codicons
            symbol_map = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
            },
        })
    end,
}
