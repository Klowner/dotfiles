--[[
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

th = {
	[70] = '#ff00ff',
	[80] = '#ffff00',
	[90] = '#ff0000',
}

]]--

function gradient(value, a, b)
	return colorizer.tohex(
		colorizer.blend(
			value,
			colorizer.torgb(a),
			colorizer.torgb(b)
		)
	)
end

--require '/home/mark/.dotfiles/dzen2/scripts/colorizer.lua'

function number_of_cores()
	return tonumber(string.sub(conky_parse("${exec grep 'cores' /proc/cpuinfo | head -1 | cut -f 2 "), 2))
end


function conky_cpuavg()
	local color = gradient(conky_parse("${cpu cpu1}")/100.0, "#ffffff", "#00ff00")
	return "^fg(".. color ..")" .. conky_parse("${cpu cpu1}") .. color .. "moooo"
end

function conky_cpustats(iconpath, acolor, bcolor)
	local cores = number_of_cores()
	local procs = conky_parse('${exec nproc}')/cores
	local avgs = {}
	local sum = 0
	local out =''
	local color

	for i=1,cores do
		for j=1,procs do
			avgs[i] = (avgs[i] or 0) + (tonumber(conky_parse('${cpu cpu' .. i .. '}')) or 0) / procs
		end
		sum = sum + (avgs[i] / cores)
	end

	for i=1,cores do
		out = out .. string.format("%3d", avgs[i])
	end

	color = gradient(sum/100, acolor, bcolor)
	sum = string.format("%2d%%", tonumber(sum))

	return '^fg(' .. color .. ')^i('..iconpath..')^fg(#ffffff)' ..  out
end

