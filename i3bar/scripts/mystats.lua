COLOR_NEUTRAL = '#aaaab0'
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
		"memory " ..
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
	local warn_thresh = 10
	local color = COLOR_GOOD

	if string.sub(battery_short, 0, 1) == 'D' and battery_percent < warn_thresh then
		color = COLOR_BAD
	end

	local status = string.sub(battery_short, 0, 1) == 'D' and 'battery' or 'ac power'

	return full_line(
		color,
		status ..
		' ' .. graphs.vert_single(battery_percent) ..
		' ' .. battery_percent .. '%' ..
		' ' .. battery_time,

		graphs.vert_single(battery_percent) .. ' ' .. battery_percent .. '%'
	)

end

function conky_mystats_filesystem(fs)
	local fs_free = conky_parse("${fs_free " .. fs .. "}")
	local fs_used_perc = tonumber(conky_parse("${fs_used_perc " .. fs .. "}"))
	local color
	local warn_thresh = 80

	color = colorizer.above_threshold_gradient(fs_used_perc, COLOR_GOOD, COLOR_BAD, warn_thresh)

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
