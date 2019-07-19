#!/bin/sh
POLYBAR_CONFIG=/home/mark/dotfiles-refresh/.config/polybar/config

# kill polybar and wait for shutdown
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# display 'primary' bar on primary display and 'secondary' bar on all other displays
for display in $(xrandr --listactivemonitors | tail -n +2 | awk '{ print$2 }'); do
	display=${display:1}  # discard leading '+'
	isprimary=$(expr match ${display} '^\*')  # is this the primary display?
	if [[ $isprimary -eq 1 ]]; then
		MONITOR="${display:1}" polybar primary -r --config-file=${POLYBAR_CONFIG} &
	else
		MONITOR="$display" polybar secondary -r --config-file=${POLYBAR_CONFIG} &
	fi
done
