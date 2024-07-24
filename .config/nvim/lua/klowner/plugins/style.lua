local function get_color(name, attr)
		return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(name)), attr):gsub('#','')
end

local function clamp(value)
	return math.min(math.max(value, 0), 255)
end

local function brightness(color, amount)
	local num = tonumber(color, 16)
	local r = (math.floor(num / 0x10000)) + amount
	local g = (math.floor(num / 0x100) % 0x100) + amount
	local b = (math.floor(num % 0x100)) + amount
	return string.format("#%x", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b))
end

local function add_tweaks()
	-- always set IblIndent to a slightly brighter version of the background color
	vim.cmd('hi IblIndent guifg=' .. brightness(get_color('Normal', 'bg'), 20))
end

return {
	'AlphaTechnolog/pywal.nvim',
	config = function ()
		vim.cmd('colorscheme pywal')
		add_tweaks()
	end,
}
