require 'io'
require 'table'
require 'string'

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
	return finder('find /sys/class/net/ -name en*')
end

function finder_wlan()
	return finder('find /sys/class/net/ -name wl*')
end

function finder_vnet()
	return finder('find /sys/class/net/ -name vnet*')
end

function finder_filesystems(path)
	return finder_configfiles(path .. '/filesystems')
end

finder_wlan()
finder_ethernet()
finder_battery()
finder_vnet()
finder_filesystems('/home/mark/.dotfiles/i3bar/config')



