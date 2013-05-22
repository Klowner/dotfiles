# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="fishy"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias wallpaper="feh --bg-scale -z"
alias svim='EDITOR=vim sudoedit'
alias sudo="nocorrect sudo"
alias steam="SDL_AUDIODRIVER=alsa steam"
alias chrome="google-chrome --audio-buffer-size=2048"

# Add extra identities to ssh-agent plugin
zstyle :omz:plugins:ssh-agent id_rsa id_rsa_storm

# Enable agent forwarding
zstyle :omz:plugins:ssh-agent agent-forwarding on

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras svn extract node npm python pip rsync systemd archlinux ssh-agent)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl
export PATH=$HOME/bin:$PATH

# npm modules
export PATH=$PATH:/home/mark/node_modules/.bin

# Misc exports
export LOCAL_PACKAGE_SOURCES=$HOME/Downloads
export EDITOR=vim
