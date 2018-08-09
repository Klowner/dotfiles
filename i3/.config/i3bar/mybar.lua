local devices = (function()
	local cache = {}
	local devices

	function gen_finder(find_cmd, match_fn)
		return function ()
			local items = {}
			match_fn = match_fn or function (line)
				return line:gmatch("./([A-Za-z0-9]+)$")()
			end

			for line in io.popen(find_cmd):lines() do
				table.insert(items, match_fn(line))
			end
			return items
		end
	end

	local finders = {
		['eth'] = gen_finder('find /sys/class/net/ -name e*'),
		['wlan'] = gen_finder('find /sys/class/net/ -name wl*'),
		['tun'] = gen_finder('find /sys/class/net/ -name tun*'),
	}

	function find_cached(finder)
		return function(rescan)
			if rescan then
				cache[finder] = nil
			end
			local res = cache[finder]
			if res == nil then
				res = finders[finder]()
				cache[finder] = res
			end
			return res
		end
	end

	function find_multi(id, finders)
		return function ()
			local res = {}
			for _, finder in ipairs(finders) do
				for _, item in ipairs(devices[finder]()) do
					table.insert(res, item)
				end
			end
			return res
		end
	end

	devices = {
		eth = find_cached('eth'),
		wlan = find_cached('wlan'),
		tun = find_cached('tun'),
		networks = find_multi('networks', {'eth', 'wlan', 'tun'}),
		-- battery = get_battery_fn(),
	}

	return devices
end)()

local graphs = (function()
	function val_to_nth(value, count)
		if type(value) == 'number' then
			return math.floor(((value / 100) * count) + 0.5)
		end
		return 0
	end

	function gen_chart_func(elements)
		local count = #elements
		return function (value)
			return elements[val_to_nth(value, count - 1) + 1]
		end
	end

	local elements_vert = {' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
	local elements_horiz = {' ', ' ','▏', '▍', '▌', '▋', '▊', '▉', '█'}
	local elements_battery = {'', '', '', '', '',}

	return {
		['vert'] = gen_chart_func(elements_vert),
		['horiz'] = gen_chart_func(elements_horiz),
		['battery'] = gen_chart_func(elements_battery),
	}
end)()

local scroller = (function()
	local states = {}

	function get_or_create_state(id, mode)
		if type(states[id]) == nil then
			states[id] = {
				x = 0,
				m = mode,
			}
		end
		return states[id]
	end

	function gen(mode)
		return function(id, str)
			return str
		end
	end

	return {
		['left'] = gen('left')
	}
end)()


function full_line(color, text, short)
	short = short or text
	return
		'"full_text": "' .. text .. '", ' ..
		(color and ('"color": "' .. color .. '", ') or '') ..
		'"short_text": "' .. short .. '"'
end

function battery()
	local pct = conky_parse('${battery_percent}')
	-- return graphs.battery(9) --'h' --graphs.battery(99)
	return graphs.battery(100) .. pct .. '%'
end

function conky_mybar_init()
end

function iface_is_up(iface)
	return conky_parse("${if_up " .. iface .. "}u${else}${endif}") == 'u'
end


function conky_mybar_foo()
	-- return '{' .. full_line(nil, conky_parse('${battery_percent}%')) .. '},'
	return '{' .. full_line(nil, battery()) .. '},'
end
