return {
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false, -- already lazy by filetype internally
        ft = { "rust" },
        config = function()
            -- rustaceanvim is configured via vim.g.rustaceanvim, NOT a setup() call
            vim.g.rustaceanvim = {
                -- ── Tools (UI / runners) ─────────────────────────────────────────
                tools = {
                    hover_actions = {
                        auto_focus = true, -- focus the hover window so you can act immediately
                    },
                    float_win_config = {
                        border = "rounded",
                    },
                    -- Show test results inline when running :RustLsp testables
                    test_executor = "background",
                },

                -- ── LSP / rust-analyzer settings ─────────────────────────────────
                server = {
                    on_attach = function(_, bufnr)
                        local map = function(mode, lhs, rhs, desc)
                            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                        end

                        -- Rust-specific actions (beyond standard LSP keys)
                        map("n", "<leader>ra", function() vim.cmd.RustLsp("codeAction") end,        "Rust code actions")
                        map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end,         "Rust runnables")
                        map("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end,         "Rust testables")
                        map("n", "<leader>rd", function() vim.cmd.RustLsp("debuggables") end,       "Rust debuggables")
                        map("n", "<leader>rm", function() vim.cmd.RustLsp("expandMacro") end,       "Expand macro")
                        map("n", "<leader>rp", function() vim.cmd.RustLsp("parentModule") end,      "Go to parent module")
                        map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end,         "Open Cargo.toml")
                        map("n", "<leader>rh", function() vim.cmd.RustLsp { "hover", "actions" } end, "Rust hover actions")
                        map("n", "<leader>re", function() vim.cmd.RustLsp("explainError") end,      "Explain error under cursor")
                        map("n", "<leader>rD", function() vim.cmd.RustLsp("renderDiagnostic") end,  "Render diagnostic")
                        map("n", "<leader>ro", function() vim.cmd.RustLsp("externalDocs") end,      "Open docs.rs")

                        -- Inlay hints toggle (Neovim 0.10+ built-in)
                        map("n", "<leader>ri", function()
                            vim.lsp.inlay_hint.enable(
                                not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                                { bufnr = bufnr }
                            )
                        end, "Toggle inlay hints")
                    end,

                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = { enable = true },
                            },
                            check = {
                                command = "clippy",
                                extraArgs = { "--no-deps" },
                            },
                            diagnostics = {
                                enable = true,
                                experimental = { enable = true },
                            },
                            procMacro = {
                                enable = true,
                                ignored = {
                                    -- Ignore tracing macros that slow down RA
                                    ["async-trait"] = { "async_trait" },
                                    ["napi-derive"] = { "napi" },
                                    ["async-recursion"] = { "async_recursion" },
                                },
                            },
                            -- Rich inlay hints — this is what gives you type annotations
                            -- inline while you code. Toggle per-buffer with <leader>ri
                            inlayHints = {
                                bindingModeHints        = { enable = false },
                                chainingHints           = { enable = true },  -- x.foo()\n  .bar()  ← shows type after each chain
                                closingBraceHints       = { enable = true, minLines = 20 },
                                closureReturnTypeHints  = { enable = "with_block" },
                                lifetimeElisionHints    = { enable = "skip_trivial", useParameterNames = true },
                                maxLength               = 30,
                                parameterHints          = { enable = true },  -- fn foo(|x: i32|) ← shows param names at callsite
                                reborrowHints           = { enable = "mutable" },
                                renderColons            = true,
                                typeHints = {
                                    enable = true,
                                    hideClosureInitialization = false,
                                    hideNamedConstructor      = false,
                                },
                            },
                            hover = {
                                actions = {
                                    enable     = true,
                                    references = { enable = true },
                                    run        = { enable = true },
                                    debug      = { enable = true },
                                },
                                documentation   = { enable = true },
                                links           = { enable = true },
                                memoryLayout    = { enable = true }, -- shows struct memory layout in hover!
                            },
                            -- Helps with large workspaces (avoids "Roots Scanned" hangs)
                            files = {
                                exclude = { ".direnv", ".git", ".github", "target", ".venv", "node_modules" },
                            },
                        },
                    },
                },

                -- ── DAP (debug adapter) ───────────────────────────────────────────
                -- rustaceanvim auto-detects codelldb or lldb from PATH or Mason.
                -- Install codelldb via Mason (:MasonInstall codelldb) and it just works.
                dap = {
                    autoload_configurations = true,
                },
            }
        end,
    },

    -- ── crates.nvim ───────────────────────────────────────────────────────────
    -- Inline Cargo.toml version info, auto-completion for crate names/versions,
    -- and upgrade suggestions directly in the editor.
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            completion = {
                crates = { enabled = true },
            },
            lsp = {
                enabled    = true,
                actions    = true,
                completion = true,
                hover      = true,
            },
        },
    },
}
