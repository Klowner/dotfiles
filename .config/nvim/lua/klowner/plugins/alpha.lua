return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function ()
		local alpha = require('alpha')
		local dashboard = require 'alpha.themes.dashboard'

		dashboard.section.header.val = {
			"          ▜█▙           ",
			"       █▄     ▄█▄       ",
			"      ████▄ ▄████▄      ",
			"     ██▀█████▀▀███▄     ",
			"    ██   ▀█▀   ▀███▄    ",
			"▄▄▄██ █████████▄▀███▄▄▄▄",
			"▀███  ███    ███ ▀█████▀",
			"      █████████▀  ▄▄▄   ",
			"      ███▀██▄    ▀▀███  ",
			"      ███  ▀██▄▄  ▄███  ",
			"       ▀▀    ▀██████▀   ",
			"          ▜█▙           ",
		}
		alpha.setup(dashboard.opts)
		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
