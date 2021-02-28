alias wallpaper="feh --bg-fill -z"
alias retheme="wal -q -t -i ~/wallpaper --saturate 0.8"
alias svim="sudo nvim"
alias capesc="setxkbmap -option caps:escape"
alias mapstylus='xinput --map-to-output $(xinput --list --id-only "ELAN2514:00 04F3:2594 Pen Pen (0)") eDP-1'
#alias rsync="noglob rsync"
alias tmux="TERM=xterm-256color tmux"

# Make `sudo` respect aliases
alias sudo='sudo '

# Enable colorized `ls`
if [[ -n "${ZSH_VERSION}" ]]; then
	alias ls='ls -p --color=auto $=LS_OPTIONS'
elif [[ -n "${BASH_VERSION}" ]]; then
	alias ls='ls -p --color=auto $LS_OPTIONS'
fi

# Alias dig to drill on boxes where I don't have dig but do have drill
if (( ! $+commands[dig] && $+commands[drill] )) then
	alias dig='drill'
fi

# Handy `ls` aliases
alias ll='ls -alF'
alias la='ls -A'

# Enable grep color
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Default editor alias
alias edit='${EDITOR}:-vim}'

#Prefer neovim if available
if (( $+commands[nvim] )) then
	alias vim='nvim'
	alias vimdiff='nvim -d'
fi
