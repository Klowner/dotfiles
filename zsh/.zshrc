# vim: set ft=zsh:
ZSH_CONFIG_DIR="${0:A:h}"

# options
setopt AUTO_CD              # If command typed is a directory, auto change to it
setopt HIST_IGNORE_DUPS     # Ignore duplicate history entries
setopt HIST_REDUCE_BLANKS   # Reduce blacks from commands in history
setopt EXTENDED_HISTORY     # Include more information about command executed, etc
setopt COMPLETE_IN_WORD     # Allow completion from within a word/phrase
setopt PROMPT_SUBST         # Enable parameter expansion, etc. in prompt

# source individual config files
function() {
	local _file
	if [[ -e "$1" ]]; then
	for _file in "$1"/*; do
			[[ "${_file}" == *'*' ]] && continue
			source "${_file}"
		done
	fi
} "${ZSH_CONFIG_DIR}/.zsh"

# fuzzy finder!
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
