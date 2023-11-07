#!/bin/sh
POLYBAR_CONFIG=$(dirname $0)/config

# kill polybar and wait for shutdown
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

displays=($(xrandr --listactivemonitors | tail -n +2 | awk '{ print $2 }'))

# display 'primary' bar on primary display and 'secondary' bar on all other displays
for display in ${displays[@]}; do
	# discard leading '+'
	display=${display:1} 

	# If display name begins with '*' (primary) or only one display is available
	isprimary=0
	if [ $(expr match ${display} '^\*') -eq 1 ] || [ ${#displays[@]} -eq 1 ]; then
		isprimary=1
	fi

	# Choose appropriate configuration depending whether or not this is a primary display
	[ $isprimary -eq 1 ] && config='primary' || config='secondary'

	# Clean up the display name
	display=${display#"*"} # discard leading '*' if present

	echo $display $isprimary $config
	# Launch polybar!
	MONITOR=${display} polybar ${config} -r --config-file=${POLYBAR_CONFIG} &
done
