return {
    "neovim/nvim-lspconfig",
    lazy = true, -- Lazy-load the plugin
    event = { 'BufReadPre', 'BufNewFile' }, -- Load only when opening a file
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()

        -- Add this at the end of your config function before the last end
        local function on_attach(client, bufnr)
            -- Disable document highlighting in normal mode
            client.server_capabilities.documentHighlightProvider = false

            -- If you also want to disable semantic tokens for all servers
            client.server_capabilities.semanticTokensProvider = nil
        end

        require("fidget").setup({})
        local ls = require("luasnip")  -- Ensure LuaSnip is required
        ls.add_snippets("c", {
            ls.snippet("for", {
                ls.text_node("for (int "),
                ls.insert_node(1, "i"),
                ls.text_node(" = 0; "),
                ls.insert_node(2, "i"),
                ls.text_node(" < "),
                ls.insert_node(3, "n"),  -- You can change this to a more fitting placeholder
                ls.text_node("; "),
                ls.insert_node(4, "i"),
                ls.text_node("++) {"),
                ls.text_node({"", "\t"}), -- Adds a new line and indentation inside the loop
                ls.insert_node(5),  -- Cursor jumps here for the user to write the loop body
                ls.text_node({"", "}"})
            }),
        })

        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local lspconfig = require("lspconfig")
        lspconfig.clangd.setup({
            cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
            init_options = {
                fallbackFlags = { "-std=c99" },
            },
            capabilities = {
                semanticTokensProvider = false
            },
            root_dir = require("lspconfig.util").root_pattern("CMakeLists.txt", ".git"),
        })
        lspconfig.lua_ls.setup ({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                    }
                }
            }
        })
        lspconfig.nil_ls.setup {
            autostart = true,
            on_attach = on_attach,
            settings = {
                ['nil'] = {
                    formatting = {
                        command = { "nixfmt" },
                    },
                },
            },
        }

        lspconfig.pyright.setup({
            on_attach = on_attach,
            settings = {
                python = {
                    checkOnType = false, -- Enable live type checking
                    diagnostics = false,  -- Enable diagnostics
                    inlayHints = false,   -- Enable inlay hints
                    smartCompletion = true, -- Smarter auto-completion
                },
            },
            capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Add completion support if using nvim-cmp
        })
        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<tab>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                    { name = 'buffer' },
                })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
