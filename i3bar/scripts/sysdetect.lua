require 'io'
require 'string'

sysdetect = {
	['battery'] = function ()
		if not sysdetect._battery then
			for line in io.popen('find /sys/class/power_supply -name BAT*'):lines() do
				sysdetect._battery = 'BAT' .. string.sub(line, string.len(line))
			end
		end
		return sysdetect._battery
	end
}

function conky_sysdetect_battery()
	return sysdetect.battery()
end


