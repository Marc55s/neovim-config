return {
    "neovim/nvim-lspconfig", -- Still used for server-specific default configs
    lazy = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "onsails/lspkind.nvim", -- Added since you use it in cmp
        "j-hui/fidget.nvim",
        "williamboman/mason.nvim",
    },

    config = function()
        require("fidget").setup({})
        local ls = require("luasnip")

        -- 1. SNIPPETS
        ls.add_snippets("c", {
            ls.snippet("for", {
                ls.text_node("for (int "), ls.insert_node(1, "i"),
                ls.text_node(" = 0; "), ls.insert_node(2, "i"),
                ls.text_node(" < "), ls.insert_node(3, "n"),
                ls.text_node("; "), ls.insert_node(4, "i"),
                ls.text_node("++) {"),
                ls.text_node({ "", "\t" }), ls.insert_node(5),
                ls.text_node({ "", "}" })
            }),
        })

        -- 2. CAPABILITIES
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- 3. LSP SERVER CONFIGURATION (New Native API)
        -- We use vim.lsp.config to define settings and vim.lsp.enable to start them.

        -- Clangd
        vim.lsp.config("clangd", {
            cmd = { 
                "clangd", "--background-index", "--clang-tidy", "--log=verbose",
                "--completion-style=detailed", "--fallback-style=file", "--all-scopes-completion=false"
            },
            init_options = { fallbackFlags = { "-std=c99" } },
            capabilities = capabilities,
            -- NEW: Use root_markers instead of root_pattern
            root_markers = { "CMakeLists.txt", ".git" },
        })
        vim.lsp.enable("clangd")

        -- Lua
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = {
                        globals = { "vim", "bit", "it", "describe", "before_each", "after_each" },
                    },
                }
            }
        })
        vim.lsp.enable("lua_ls")

        -- Nil (Nix)
        vim.lsp.config("nil_ls", {
            capabilities = capabilities,
            settings = {
                ['nil'] = { formatting = { command = { "nixfmt" } } },
            },
        })
        vim.lsp.enable("nil_ls")

        -- Pyright
        vim.lsp.config("pyright", {
            capabilities = capabilities,
            settings = {
                python = {
                    checkOnType = false,
                    diagnostics = false,
                    smartCompletion = true,
                },
            },
        })
        vim.lsp.enable("pyright")

        -- Rust
        vim.lsp.config("rust_analyzer", {
            capabilities = capabilities,
            settings = {
                ['rust-analyzer'] = {
                    cargo = { allFeatures = true },
                    check = { command = 'clippy' },
                },
            },
        })
        vim.lsp.enable("rust_analyzer")

        -- Arduino
        vim.lsp.config("arduino_language_server", {
            cmd = {
                "arduino-language-server",
                "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
                "-fqbn", "arduino:avr:uno",
                "-cli", "arduino-cli",
                "-clangd", "clangd"
            }
        })
        vim.lsp.enable("arduino_language_server")

        -- 4. COMPLETION SETUP (nvim-cmp)
        local cmp = require('cmp')
        cmp.setup({
            snippet = { expand = function(args) ls.lsp_expand(args.body) end },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<tab>"] = cmp.mapping.select_next_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            }),
            formatting = {
                format = require("lspkind").cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    menu = { buffer = "[buf]", nvim_lsp = "[LSP]", luasnip = "[snip]" },
                }),
            },
        })

        -- 5. DIAGNOSTICS
        vim.diagnostic.config({
            virtual_text = { spacing = 4, prefix = "●" },
            signs = true,
            underline = true,
            float = { border = "rounded", source = "always" },
        })
    end
}
