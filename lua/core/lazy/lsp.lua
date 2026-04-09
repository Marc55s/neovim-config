return {
    "neovim/nvim-lspconfig",
    lazy = true,                            -- Lazy-load the plugin
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
        "onsails/lspkind.nvim",
    },

    config = function()
        require("fidget").setup({})
        local ls = require("luasnip") -- Ensure LuaSnip is required
        ls.add_snippets("c", {
            ls.snippet("for", {
                ls.text_node("for (int "),
                ls.insert_node(1, "i"),
                ls.text_node(" = 0; "),
                ls.insert_node(2, "i"),
                ls.text_node(" < "),
                ls.insert_node(3, "n"), -- You can change this to a more fitting placeholder
                ls.text_node("; "),
                ls.insert_node(4, "i"),
                ls.text_node("++) {"),
                ls.text_node({ "", "\t" }), -- Adds a new line and indentation inside the loop
                ls.insert_node(5),          -- Cursor jumps here for the user to write the loop body
                ls.text_node({ "", "}" })
            }),
        })

        local cmp = require("cmp")

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.semanticTokens = {
            dynamicRegistration = true,
            overlappingTokenSupport = true,
            multilineTokenSupport = true,
        }

        -- 1. Modern UI Overrides (No deprecation warnings)
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or "rounded"

            local bufnr, winid = orig_util_open_floating_preview(contents, syntax, opts, ...)

            -- This is the "Magic" that makes Markdown look fancy
            if syntax == "markdown" then
                -- We use schedule to ensure the window is fully initialized
                -- before applying window-local options
                vim.schedule(function()
                    if vim.api.nvim_win_is_valid(winid) then
                        vim.wo[winid].conceallevel = 2
                        vim.wo[winid].concealcursor = "nc"
                        -- This kills the "squared" background look
                        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
                        vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
                    end
                end)
            end

            return bufnr, winid
        end

        -- 2. Diagnostic config (Keep this for the popups that show errors)
        vim.diagnostic.config({
            float = { border = "rounded" },
        })

        vim.lsp.config["clangd"] = {
            cmd = { "clangd",
                "--background-index",
                "--clang-tidy",
                "--log=verbose",
                "--completion-style=detailed",
                "--fallback-style=file",
                "--all-scopes-completion=false"
            },
            init_options = {
                fallbackFlags = { "-std=c99" },
                useDefaultFallbackStyle = false,
            },
            capabilities = capabilities,
            root_markers = { "CMakeLists.txt", ".git", ".clang-format" },
        }
        vim.lsp.enable("clangd")

        vim.lsp.config["lua_ls"] = {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                    }
                }
            }
        }
        vim.lsp.enable("lua_ls")

        vim.lsp.config["nil_ls"] = {
            autostart = true,
            settings = {
                ['nil'] = {
                    formatting = {
                        command = { "nixfmt" },
                    },
                },
            },
        }
        vim.lsp.enable("nil_ls")

        vim.lsp.config["pyright"] = {
            settings = {
                python = {
                    checkOnType = false,    -- Enable live type checking
                    diagnostics = false,    -- Enable diagnostics
                    inlayHints = false,     -- Enable inlay hints
                    smartCompletion = true, -- Smarter auto-completion
                },
            },
            capabilities = require("cmp_nvim_lsp").default_capabilities(), -- Add completion support if using nvim-cmp
        }
        vim.lsp.enable("pyright")

        vim.lsp.config["texlab"] = {
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
        }
        vim.lsp.enable("texlab")

        vim.lsp.config["neocmake"] = {
            root_markers = { "CMakeLists.txt", ".git", "compile_commands.json" },
            init_options = {
                format = { enable = true },
                lint = { enable = true },
                scan_cmake_in_package = true
            }
        }
        vim.lsp.enable("neocmake")

        vim.lsp.config["arduino_language_server"] = {
            cmd = {
                "arduino-language-server",
                "-cli-config", "/home/you/.arduino15/arduino-cli.yaml",
                "-fqbn", "arduino:avr:uno", -- change to your board
                "-cli", "arduino-cli",
                "-clangd", "clangd"
            }
        }
        vim.lsp.enable("arduino_language_server")
        local lspkind = require("lspkind")

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
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
                fields = { "abbr", "icon", "kind", "menu" },
                -- fields = { "kind", "abbr", "menu" },
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 30,
                    ellipsis_char = "...",
                    menu = {
                        nvim_lsp = 'λ',
                        luasnip  = '⋗',
                        buffer   = 'Ω',
                        path     = '🖫',
                    },
                }),
            },
        })

        vim.diagnostic.config({
            virtual_text = {
                spacing = 4,
                prefix = "●", -- Or ">>", ">", "●", etc.
            },
            signs = true,
            underline = true,
            update_in_insert = false,
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
