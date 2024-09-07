return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp", -- Optional: For activating slash commands and variables in the chat buffer
		"nvim-telescope/telescope.nvim", -- Optional: For working with files with slash commands
		{
			"stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
			opts = {},
		},
	},
	config = function ()
		require('codecompanion').setup({
			strategies = {
				chat = { adapter = 'ollama' },
				inline = { adapter = 'ollama' },
				agent = { adapter = 'ollama' },
			},
			adapters = {
				ollama = function ()
					return require('codecompanion.adapters').extend('ollama', {
						schema = {
							model = {
								default = 'yi-coder:1.5b',
							},
						},
						env = {
							url = "https://localhost:11434",
						},
					})
				end,
			},
		})
	end,
}
