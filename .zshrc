# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="fishy"

# Example aliases
alias wallpaper="feh --bg-fill -z"
alias svim='EDITOR=vim sudoedit'
alias sudo="nocorrect sudo"
alias steam="SDL_AUDIODRIVER=alsa steam"

# Add extra identities to ssh-agent plugin
zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa_storm

# Enable agent forwarding
zstyle :omz:plugins:ssh-agent agent-forwarding on

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
	archlinux
	django
	#encode
	#extract
	git-extras
	gitfast
	#npm
	#pip
	#rsync
	#screen
	ssh-agent
	systemd
	#vundle
	)

source /etc/profile

if [ -e $HOME/.zshrc.local ]; then
	source $HOME/.zshrc.local
fi

source $ZSH/oh-my-zsh.sh

# Thank you, Adam Stankiewicz!
fancy-ctrl-z () {
	if [[ $#BUFFER -eq 0 ]]; then
		fg
		zle redisplay
	else
		zle push-input
		zle clear-screen
	fi
}
zle -N fancy-ctrl-z

bindkey '^Z' fancy-ctrl-z

# My local ~/bin
export PATH=$HOME/bin:$PATH

# npm modules
export PATH=$PATH:/home/mark/node_modules/.bin

# ruby gems
export PATH=$PATH:$HOME/.gem/ruby/2.0.0/bin

# Misc exports
export LOCAL_PACKAGE_SOURCES=$HOME/Downloads
export EDITOR=vim

export XDG_CONFIG_HOME=~/.config
