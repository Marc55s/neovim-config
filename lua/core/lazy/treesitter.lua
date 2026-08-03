return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- load at startup so parser install runs and the highlight autocmd is registered
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter').setup()

        -- Parsers to keep installed (aligned with the configured LSP servers).
        local ensure = {
            'lua', 'vim', 'vimdoc', 'query',
            'c', 'cpp', 'cmake',
            'rust',
            'python',
            'haskell',
            'javascript', 'typescript', 'tsx',
            'html', 'css',
            'json', 'yaml', 'toml',
            'markdown', 'markdown_inline',
            'bash',
            'haskell'
        }
        require('nvim-treesitter').install(ensure)

        -- The main branch does NOT enable highlighting automatically; do it per-buffer.
        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                -- start() errors if no parser is installed for this filetype yet,
                -- so guard it while parsers are still compiling / for unsupported filetypes.
                pcall(vim.treesitter.start, args.buf)
                -- treesitter-based indentation (experimental on main)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
}
