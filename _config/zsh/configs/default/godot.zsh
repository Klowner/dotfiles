
# if neovim-remote is present, create an alias for nvim
if (( $+commands[nvr] )) then
	alias gdvim="NVIM_LISTEN_ADDRESS=/tmp/$USER-godot nvr"
fi
