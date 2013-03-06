#!/bin/sh

# Call standard xinitrc.d scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [ -d ~/.dotfiles/xinitrc ]; then
	for x in "all" "$(hostname -s)"; do
		x=~/.dotfiles/xinitrc/xinitrc.$x
		[ -x "$x" ] && . "$x"
	done
	unset x
fi


#xsetroot -cursor_name left_ptr &
#dispcalGUI-apply-profiles &
#feh --bg-scale -z ~/Dropbox/Wallpapers/external &
#thunar --daemon &
#gvolwheel -d hw:1 &
#clipit &


exec i3
