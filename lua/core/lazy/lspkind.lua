return {
  "onsails/lspkind.nvim",
  event = "InsertEnter",  -- Use InsertEnter to ensure it loads for autocompletion
  config = function()
    require("lspkind").init({
      mode = "symbol_text", -- Show both symbols and text annotations
      preset = "codicons",  -- Use VSCode Codicons
      symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
      },
    })

    -- Ensure integration with nvim-cmp
    local cmp = require("cmp")
    cmp.setup({
      formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = require("lspkind").cmp_format({
          with_text = true,  -- Optional: show text with the icon
          menu = {
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          },
        }),
      },
    })
  end,
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
