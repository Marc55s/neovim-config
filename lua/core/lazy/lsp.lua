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
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },

    config = function()


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

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        --require("mason").setup()  -- Ensure Mason is set up first

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local lspconfig = require("lspconfig")

        lspconfig.clangd.setup({
            cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" , "--fallback-style=file" },
            init_options = {
                fallbackFlags = { "-std=c99" },
            },
            capabilities = vim.lsp.protocol.make_client_capabilities(),
            root_dir = require("lspconfig.util").root_pattern("CMakeLists.txt", ".git"),
        })
        lspconfig.lua_ls.setup ({
            capabilities = capabilities,
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
            settings = {
                ['nil'] = {
                    formatting = {
                        command = { "nixfmt" },
                    },
                },
            },
        }

        lspconfig.pyright.setup({
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

        lspconfig.texlab.setup({
            settings = {
                texlab = {
                    build = {
                        executable = "latexmk",
                        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                        onSave = true
                    },
                    forwardSearch = {
                        executable = "zathura",
                        args = { "--synctex-forward", "%l:1:%f", "%p" }
                    }
                }
            }
        })

        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            settings = {
                ['rust-analyzer'] = {
                    cargo = {
                        allFeatures = true,
                    },
                    checkOnSave = {
                        command = 'clippy',
                    },
                    diagnostics = {
                        enable = true,
                    },
                },
            },
        })


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
