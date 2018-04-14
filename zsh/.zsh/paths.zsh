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
if [ -x /usr/bin/colorgcc ]; then
	export PATH="/usr/lib/colorgcc/bin/:$PATH"
	export CCACHE_PATH="/usr/bin"
elif [ -x /usr/bin/ccache ]; then
	export PATH="/usr/lib/ccache/bin/:$PATH"
fi


