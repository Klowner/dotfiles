return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function ()
		local nvimtree = require('nvim-tree')

		-- recommended settings from the nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			view = {
				width = 35,
				relativenumber = true,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			git = {
				ignore = false
			},
		})

		vim.keymap.set('n', '\\e', '<cmd>NvimTreeToggle<cr>', {desc = "Toggle file explorer" })
	end
}
