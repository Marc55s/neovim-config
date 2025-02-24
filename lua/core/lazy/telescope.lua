return {
	-- plugins/telescope.lua:
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
    cmd = 'Telescope', -- Load only when using `:Telescope`
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		require('telescope').setup({})

		local builtin = require('telescope.builtin')
	end
}
