return {
    'oxy2dev/markview.nvim',
    lazy = true,
    ft = { 'markdown' },
    config = function()
        require('markview').setup({
            theme = 'dark',  -- Set theme to 'light' or 'dark'
            auto_start = false,  -- Automatically start the preview on entering a markdown file
            preview = {
                enable = false,
            }
        })
        -- Add keymap to toggle splitview with leader+tm
        vim.api.nvim_set_keymap(
            'n',
            '<leader>tm',
            ':Markview splitToggle<CR>',
            { noremap = true, silent = true }
        )

    end,
}
