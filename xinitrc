#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Merge .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# export ssh-user-agent variables
eval $(systemctl --user show-environment | grep SSH_AUTH_SOCK)
export SSH_AUTH_SOCK

# setxkbmap -option caps:swapescape &

# Per-host init
filepath=$(dirname $(readlink -f $0))
for f in "all" "$(hostname)"; do
	f="${filepath}/_xinitrc/xinitrc.$f"
	echo $f
	[ -e "$f" ] && . "$f"
done
unset filepath

# Launch i3!
exec i3
