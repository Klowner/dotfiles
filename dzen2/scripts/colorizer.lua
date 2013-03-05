colorizer = {
	['tohex'] = function (rgb)
		local res = '#'
		for i=1,#rgb do
			res = res .. string.format("%02X", rgb[i])
		end
		return res
	end,

	['torgb'] = function (hex)
		res = {}
		for x=1,3 do
			res[x] = tonumber(string.sub(hex, x*2, x*2+1), 16)
		end
		return res
	end,

	['blend'] = function (amount, a, b)
		res = {}
		amount = math.min(amount, 1)
		for x=1,3 do
			res[x] = a[x] * (1.0-amount) + b[x] * amount
		end
		return res
	end,
}


