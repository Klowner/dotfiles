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
	return finder('find /sys/class/net/ -name e[tn]*')
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
end

function get_config()
	return _cfg
end

