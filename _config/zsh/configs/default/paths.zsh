#/// My local scripts path
export PATH=$HOME/bin:$PATH

#/// npm
export PATH=$HOME/node_modules/.bin:$PATH

#/// Go
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin

#/// Lua Rocks
export PATH=$PATH:$HOME/.luarocks/bin

#/// Ruby Gems
export PATH=$PATH:$HOME/.gem/ruby/2.4.0/bin

#/// ccache / colorgcc
# if (( $+commands[colorgcc] )); then
# 	export PATH="/usr/lib/colorgcc/bin/:$PATH"
# fi

if (( $+commands[ccache] )); then
	export CCACHE_PATH="/usr/bin"
	export PATH="/usr/lib/ccache/bin/:$PATH"
fi

export VIRSH_DEFAULT_CONNECT_URI="qemu:///system"
