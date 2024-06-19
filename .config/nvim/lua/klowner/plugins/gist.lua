return {
	{
		"rawnly/gist.nvim",
		cmd = { "GistCreate", "GistCreateFromFile", "GistList" },
		config = true,
	},
	{
		"samjwill/nvim-unception",
		lazy = false,
		init = function() vim.g.unception_block_while_host_edits = true end,
	},
}
