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

	['gradient'] = function (amount, a, b)
		return colorizer.tohex(
			colorizer.blend(
				amount,
				colorizer.torgb(a),
				colorizer.torgb(b)
			)
		)
	end,

	['above_threshold_gradient'] = function (amount, a, b, threshold)
		if amount <= threshold then
			return a
		end

		return colorizer.gradient(
			(amount - threshold) / (100 - threshold),
			a,
			b
		)
	end
}


require 'io'

function finder(find_cmd, match_fn)
	local i = 1
	local items = {}

	if not match_fn then
		match_fn = function (line)
			return line:gmatch("./([A-Za-z0-9]+)$")()
		end
	end

	for line in io.popen(find_cmd):lines() do
		items[i] = match_fn(line)
		i = i + 1
	end
	return items
end

function finder_configfiles(path)
	local hostname = io.popen('hostname'):lines()()
	local i = 1
	local f
	local items = {}

	for id, filename in ipairs({path, path .. '.' .. hostname}) do
		f = io.open(filename, 'rb')
		if f ~= nil then
			io.close(f)
			for line in io.lines(filename) do
				items[i] = line
				i = i + 1
			end
		end
	end
	return items
end

function finder_battery()
	return finder('find /sys/class/power_supply -name BAT*',
		function(line)
			return line:gmatch(".*/(BAT[0-9]+)$")()
		end)
end

function finder_ethernet()
	return finder('find /sys/class/net/ -name e*')
end

function finder_wlan()
	return finder('find /sys/class/net/ -name wl*')
end

function finder_vnet(path)
	return finder_configfiles(path .. '/vnet')
end

function finder_filesystems(path)
	return finder_configfiles(path .. '/filesystems')
end

local _cfg

function conky_config_load(config_path)
	if _cfg == nil then
		_cfg = {}
		_cfg['wlan'] = finder_wlan()
		_cfg['eth'] = finder_ethernet()
		_cfg['vnet'] = finder_vnet(config_path)
		_cfg['bat'] = finder_battery()
		_cfg['fs'] = finder_filesystems(config_path)
	end
	return ''
end

function get_config()
	return _cfg
end

graphs = {
	['val_to_8th'] = function (value)
		if type(value) == "number" then
			return math.floor(((value / 100) * 8) + 0.5) + 1
		end
		return 1
	end,

	['val_to_4th'] = function (value)
		if type(value) == "number" then
			return math.floor(((value / 100) * 4) + 0.5) + 1
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
	end,

	['battery'] = function (value)
		local chars = {'', '', '', '', ''}
		return chars[graphs.val_to_4th(value)]
	end
}
COLOR_NEUTRAL = '#707064'
COLOR_GOOD = '#00b9d9'
COLOR_BAD = '#f7208b'
COLOR_DEGRADED = '#82cdb9'

function mystats_num_cores()
	return tonumber(string.sub(conky_parse("%{exec grep 'cores' /proc/cpuinfo | head -1 | cut -f 2 "), 2))
end

function upspeed(iface)
	return '▲' .. conky_parse("${upspeed " .. iface .. "}")
end

function downspeed(iface)
	return '▼' .. conky_parse("${downspeed " .. iface .. "}")
end

function speed(iface)
	return conky_parse('(↑${upspeed ' .. iface .. '} ↓${downspeed ' .. iface .. '})')
end

function is_up(iface)
	return conky_parse("${if_up " .. iface .. "}up${else}down${endif}") == 'up'
end

function conky_mystats_vgraph(value)
	return graphs.vert_single(tonumber(value))
end

function dynamic_config_stats(key, fn)
	local cfg = get_config()[key]
	local out = ''
	for i, item in ipairs(cfg) do
		out = out .. '{ ' .. fn(item) .. '},'
	end
	return out
end

function conky_mystats_wifi_status(iface)
	local link_qual_perc = tonumber(conky_parse("${wireless_link_qual_perc " .. iface .. "}"))
	local link_essid = conky_parse("${wireless_essid " .. iface .. "}")
	local link_ip = conky_parse("${addr " .. iface .. "}")

	if not is_up(iface) then
		return {
			iface .. " down",
			iface
		}
	else
		return {iface .. " " ..
			graphs.vert_single(tonumber(conky_parse("${wireless_link_qual_perc " .. iface .. "}") or '0')) ..
				" (" .. link_essid .. ")" ..
				" " .. link_ip ..
				" " .. speed(iface),
			iface
		}
	end
end

function conky_mystats_eth_status(iface)
	local link_ip = conky_parse("${addr " .. iface .. "}")

	if not is_up(iface) then
		return {
			iface .. " down",
			iface
		}
	else
		return {
			iface ..
				" " .. link_ip ..
				" " .. speed(iface),
			iface
		}
	end
end

function conky_mystats_eth_color(iface)
	if is_up(iface) then
		return COLOR_GOOD
	end
	return COLOR_NEUTRAL
end

function conky_mystats_wifi_color(iface)
	local link_qual_perc

	if is_up(iface) then
		link_qual_perc = tonumber(conky_parse("${wireless_link_qual_perc " .. iface .. "}"))
		if link_qual_perc == nil then
			return COLOR_NEUTRAL
		end
		link_qual_perc = link_qual_perc / 100
		return colorizer.gradient(link_qual_perc, COLOR_BAD, COLOR_GOOD)
	end
	return COLOR_NEUTRAL
end


function conky_mystats_mem()
	local mem_perc_used = tonumber(conky_parse("${memperc}"))
	local mem_perc_free = 100 - mem_perc_used

	return "mem " ..
		graphs.vert_single(mem_perc_used) ..
		conky_parse(" ${mem} (${memmax})")
end

function conky_mystats_memory()
	local mem_perc_used = tonumber(conky_parse("${memperc}"))
	local mem_perc_free = 100 - mem_perc_used
	local warn_thresh = 80
	local color = colorizer.above_threshold_gradient(mem_perc_used, COLOR_GOOD, COLOR_BAD, warn_thresh)

	return full_line(
		color,
		"mem " ..
			graphs.vert_single(mem_perc_used) ..
			conky_parse(" ${mem} (${memmax} total)"),
		"ram " ..
			graphs.vert_single(mem_perc_used) ..
			conky_parse(" ${mem}")
		)
end

function conky_mystats_disk(device)
	return conky_parse("${diskio sda}")
end

function full_line(color, text, short)
	short = short or text
	return '"full_text" : "' .. text ..
			'", "short_text" : "' .. short ..
			'", "color" : "' .. color ..
			'"'
end

function conky_mystats_battery(bat)
	local battery_short = conky_parse("${battery_short " ..  bat .. "}")
	local battery_percent = tonumber(conky_parse("${battery_percent " .. bat .. "}"))
	local battery_time = conky_parse("${battery_time " .. bat .. "}")
	local warn_thresh = 15
	local color = COLOR_GOOD

	if string.sub(battery_short, 0, 1) == 'D' and battery_percent < warn_thresh then
		color = COLOR_BAD
		if tonumber(conky_parse("${time %s}"), 10) % 2 == 0 then
			color = colorizer.tohex(colorizer.blend(0.6, colorizer.torgb(color), colorizer.torgb('#ffffff')))
		end
	end


	local status = string.sub(battery_short, 0, 1) == 'D' and 'battery' or 'ac power'

	return full_line(
		color,
		status ..
		' ' .. graphs.battery(battery_percent) ..
		' ' .. battery_percent .. '%' ..
		' ' .. battery_time,

		graphs.battery(battery_percent) .. ' ' .. battery_percent .. '%'
	)

end

function conky_mystats_filesystem(fs)
	local fs_free = conky_parse("${fs_free " .. fs .. "}")
	local fs_used_perc = tonumber(conky_parse("${fs_used_perc " .. fs .. "}"))
	local color
	local warn_thresh = 80

	color = colorizer.above_threshold_gradient(fs_used_perc, COLOR_GOOD, COLOR_BAD, warn_thresh)
	fs = fs == '/' and 'root' or fs
	return full_line(
		color,
		fs .. ' ' ..
			graphs.vert_single(fs_used_perc) .. ' ' ..
			fs_free .. ' free',
		fs .. ' ' .. graphs.vert_single(fs_used_perc)
		)
end

function conky_mystats_ethernet(iface)
	return full_line(
		conky_mystats_eth_color(iface),
		unpack(conky_mystats_eth_status(iface))
	)
end

function conky_mystats_wireless(iface)
	return full_line(
		conky_mystats_wifi_color(iface),
		unpack(conky_mystats_wifi_status(iface))
	)
end

function conky_mystats_dynamic_wireless()
	return dynamic_config_stats('wlan', conky_mystats_wireless)
end

function conky_mystats_dynamic_ethernet()
	return dynamic_config_stats('eth', conky_mystats_ethernet)
end

function conky_mystats_dynamic_vnet()
	return dynamic_config_stats('vnet', conky_mystats_ethernet)
end

function conky_mystats_dynamic_filesystems()
	return dynamic_config_stats('fs', conky_mystats_filesystem)
end

function conky_mystats_dynamic_battery()
	return dynamic_config_stats('bat', conky_mystats_battery)
end
