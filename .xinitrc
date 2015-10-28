#!/bin/sh

#[[ -e /etc/profile ]] && /etc/profile;

# Call standard xinitrc.d scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Run xinitrc.all and then xinitrc.{hostname}
if [ -d ~/.dotfiles/xinitrc ]; then
	for x in "all" "$(cat /etc/hostname)"; do
		x=~/.dotfiles/xinitrc/xinitrc.$x
		[ -x "$x" ] && . "$x"
	done
	unset x
fi

# Update Xresources database
if [ -f $HOME/.Xresources ]; then
	xrdb -merge ~/.Xresources
fi

# Update i3 configs
~/.dotfiles/i3/generate

# Launch the ever so wonderful i3
exec i3 -c /tmp/i3-$USER/config

#exec awesome
