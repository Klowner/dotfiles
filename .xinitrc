#!/bin/sh

# Call standard xinitrc.d scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Run xinitrc.all and then xinitrc.{hostname}
if [ -d ~/.dotfiles/xinitrc ]; then
	for x in "all" "$(hostname -s)"; do
		x=~/.dotfiles/xinitrc/xinitrc.$x
		[ -x "$x" ] && . "$x"
	done
	unset x
fi

# Launch the ever so wonderful i3
exec i3
