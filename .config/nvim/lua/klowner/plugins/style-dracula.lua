return {
	"Mofiqul/dracula.nvim",
	cond = function ()
		return true
		-- return vim.fn.executable('wal') == 0 -- if wal is unavailable, I'll use Dracula
	end,
	config = function ()
		vim.cmd('colorscheme dracula')
	end,
}
