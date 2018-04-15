# Treat glob chars as literals when there are no matches (like bash)
setopt no_nomatch

## History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

# Don't record consecutive duplicates or lines starting with a space
setopt hist_ignore_dups
setopt hist_ignore_space

setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt hist_expire_dups_first
setopt share_history

# Append to the history file instead of over-writing it after each session
#setopt inc_append_history


# Enable Vim mode (press esc to start)
bindkey -e

# Fancy ctrl-z (thanks, Adam Stankiewicz!)
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

bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

autoload -Uz colors && colors
setopt prompt_subst

fish_pwd() {
	echo ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
}

## Prompts
PROMPT=''
if [[ ! -z "$SSH_CLIENT" ]] then
	PROMPT+="%B%F{blue}%m%b%f "
fi
PROMPT+="%F{blue}"
PROMPT+='$(fish_pwd)'
PROMPT+="❯ "
#PROMPT+=">"
PROMPT+="%f%s%b "                          # Reset colors

# Get LS_COLORS
if [[ -z "${LS_COLORS}" ]] && [[ -x '/usr/bin/dircolors' ]]; then
	eval "$( /usr/bin/dircolors -b )"
fi

## Completion Settings
######################
(( ${fpath[(I)/usr/share/zsh/site-functions]} )) ||
fpath+=( /usr/share/zsh/site-functions )

autoload -Uz compinit && compinit
zmodload zsh/complist

# Offer to correct mispelings
setopt correct

# Always display tags separately
zstyle ':completion:*' group-name ''

# Case-insensitive matching
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Show completing ____' in the menu thing
zstyle ':completion:*:descriptions' format $'%{\e[0;35m%}completing %B%d:%b%{\e[0m%}'

# Display a selection box around the completion menu items
zstyle ':completion:*' menu select=2

# Ignore users with /bin/false or /bin/nologin as their log-in shell
zstyle ':completion:*' users ${${${(f)"$( < /etc/passwd )"}:#*/(false|nologin)}%%:*}

# Define the order and display names of groups for `ssh`
zstyle ':completion:*:ssh:*' tag-order 'hosts:hosts:host users:users:user'
zstyle ':completion:*:ssh:*' group-order 'hosts users'
