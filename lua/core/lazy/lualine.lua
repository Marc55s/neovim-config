return {
    'nvim-lualine/lualine.nvim',
    event = "BufWinEnter",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- powerline slant glyphs as escapes (E0B8 = \, E0BA = /) so no
        -- special characters need to live in this file
        local sep_left = '\u{e0b8}'
        local sep_right = '\u{e0ba}'

        local colors = {
            red = '#ca1243',
            white = '#f3f3f3',
            orange = '#fe8019',
        }

        -- gap color = editor background, so the gaps blend with the
        -- current colorscheme instead of a hardcoded palette
        local function gap_bg()
            local hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
            return hl.bg and string.format('#%06x', hl.bg) or 'NONE'
        end

        local empty = require('lualine.component'):extend()
        function empty:draw(default_highlight)
            self.status = ''
            self.applied_separator = ''
            self:apply_highlights(default_highlight)
            self:apply_section_separators()
            return self.status
        end

        -- Put proper separators and gaps between components in sections
        local function process_sections(sections)
            for name, section in pairs(sections) do
                local left = name:sub(9, 10) < 'x'
                local gap = gap_bg()
                for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
                    table.insert(section, pos * 2, { empty, color = { fg = gap, bg = gap } })
                end
                for id, comp in ipairs(section) do
                    if type(comp) ~= 'table' then
                        comp = { comp }
                        section[id] = comp
                    end
                    comp.separator = left and { right = sep_left } or { left = sep_right }
                end
            end
            return sections
        end

        local function search_result()
            if vim.v.hlsearch == 0 then
                return ''
            end
            local last_search = vim.fn.getreg('/')
            if not last_search or last_search == '' then
                return ''
            end
            local searchcount = vim.fn.searchcount { maxcount = 9999 }
            return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
        end

        local function modified()
            if vim.bo.modified then
                return '+'
            elseif vim.bo.modifiable == false or vim.bo.readonly == true then
                return '-'
            end
            return ''
        end

        -- sections are rebuilt on every call so the gap color follows
        -- the active colorscheme (see ColorScheme autocmd below)
        local function apply()
            require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = '',
                section_separators = { left = sep_left, right = sep_right },
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = process_sections {
                lualine_a = { 'mode' },
                lualine_b = {
                    'branch',
                    'diff',
                    {
                        'diagnostics',
                        source = { 'nvim' },
                        sections = { 'error' },
                        diagnostics_color = { error = { bg = colors.red, fg = colors.white } },
                    },
                    {
                        'diagnostics',
                        source = { 'nvim' },
                        sections = { 'warn' },
                        diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
                    },
                    { 'filename', file_status = false, path = 1 },
                    { modified, color = { bg = colors.red } },
                    {
                        '%w',
                        cond = function()
                            return vim.wo.previewwindow
                        end,
                    },
                    {
                        '%r',
                        cond = function()
                            return vim.bo.readonly
                        end,
                    },
                    {
                        '%q',
                        cond = function()
                            return vim.bo.buftype == 'quickfix'
                        end,
                    },
                },
                lualine_c = {},
                lualine_x = {},
                -- kept from the previous config: encoding + filetype
                lualine_y = { search_result, 'encoding', 'filetype' },
                -- classic line:col + progress, like the default ruler
                -- (padded so the block doesn't resize while moving)
                lualine_z = { '%3l:%-2c', '%3p%%' },
            },
            inactive_sections = {
                lualine_c = { '%f %y %m' },
                lualine_x = {},
            },
            }
        end

        apply()

        -- re-apply with freshly computed gap color when the theme changes
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = vim.api.nvim_create_augroup('LualineGapRefresh', { clear = true }),
            callback = function()
                vim.schedule(apply)
            end,
        })
    end
}
