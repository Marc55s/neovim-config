local function save_theme(theme)
    local path = vim.fn.stdpath("data") .. "/last_theme.txt"
    local file = io.open(path, "w")
    if file then
        file:write(theme)
        file:close()
    else
        vim.notify("Error saving theme", vim.log.levels.ERROR)
    end
end

local function load_theme()
    local path = vim.fn.stdpath("data") .. "/last_theme.txt"
    local file = io.open(path, "r")
    if file then
        local theme = file:read("*l") -- Read first line
        file:close()
        if theme and #theme > 0 then
            -- Try to load the colorscheme safely
            local success = pcall(vim.cmd, "colorscheme " .. theme)
            if success then
                -- Ensure lualine updates its colors
                vim.defer_fn(function()
                    require("lualine").setup(require("lualine").get_config())
                    vim.cmd("redrawstatus")
                end, 50) -- Small delay to make sure highlights are applied
                return vim.trim(theme)
            else
                vim.notify("Colorscheme not found: " .. theme, vim.log.levels.WARN)
            end
        end
    end
    return nil
end


local autocmd = vim.api.nvim_create_autocmd

-- Load Theme on VimEnter
autocmd("VimEnter", {
    callback = function()
        local last_theme = load_theme()
        if last_theme then
            vim.cmd("colorscheme " .. last_theme)
        else
            vim.notify("No last_theme was found", vim.log.levels.WARN)
        end
    end,
})

-- Save Theme on Change
autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        local theme = vim.g.colors_name
        if theme then
            save_theme(theme)
            require('lualine').refresh()
        end
    end,
})

autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.conceallevel = 1
    end,
})

autocmd('LspAttach', {
    callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

autocmd("FileType", {
    pattern = "c",
    callback = function()
        vim.opt_local.wrap = false
    end,
})

