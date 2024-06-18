return {
	"rmagatti/auto-session",
	config = function ()
		require('auto-session').setup({
			auto_restore_enabled = false,
		})
		local keymap = vim.keymap
		keymap.set('n', '<leader>wr', '<cmd>SessionRestore<cr>', { desc = "Restore session for cwd" })
		keymap.set('n', '<leader>ws', '<cmd>SessionSave<cr>', { desc = "Save session for cwd" })
	end
}
