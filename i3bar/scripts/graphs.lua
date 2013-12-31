graphs = {
	['val_to_8th'] = function (value)
		if type(value) == "number" then
			return math.floor(((value / 100) * 8) + 0.5) + 1
		end
		return 1
	end,

	['vert_single'] = function (value)
		local chars = {' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
		return chars[graphs.val_to_8th(value)]
	end,

	['horiz_single'] = function (value)
		local chars = {' ', ' ','▏', '▍', '▌', '▋', '▊', '▉', '█'}
		return chars[graphs.val_to_8th(value)]
	end
}
