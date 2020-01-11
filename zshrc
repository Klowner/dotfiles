# vim:set ft=zsh:

# options
setopt AUTO_CD              # If command typed is a directory, auto change to it
setopt HIST_IGNORE_DUPS     # Ignore duplicate history entries
setopt HIST_REDUCE_BLANKS   # Reduce blacks from commands in history
setopt EXTENDED_HISTORY     # Include more information about command executed, etc
setopt COMPLETE_IN_WORD     # Allow completion from within a word/phrase
setopt PROMPT_SUBST         # Enable parameter expansion, etc. in prompt

# aliases
alias retheme='wal -q -t -i ~/wallpaper -saturate 0.8'
alias sudo='sudo '
alias tmux='TERM=xterm-256color tmux'
alias svim='sudo vim'
alias ll='ls -alF'
alias la='ls -A'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias edit='${EDITOR:-vim}'

local _configpath=~/.config/zsh/configs
for group in default ${HOST}; do
	local _grouppath=$_configpath/$group
	if [[ -d $_grouppath ]]; then
		for cfg in $_grouppath/*.zsh; do
			source $cfg
		done
	fi
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.aliases ] && source ~/.aliases

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/mark/code/ereloom.io/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/mark/code/ereloom.io/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/mark/code/ereloom.io/node_modules/tabtab/.completions/sls.zsh ]] && . /home/mark/code/ereloom.io/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/mark/code/ereloom.io/node_modules/tabtab/.completions/slss.zsh ]] && . /home/mark/code/ereloom.io/node_modules/tabtab/.completions/slss.zsh
