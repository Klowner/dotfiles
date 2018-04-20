GIT_PROMPT_PREFIX=""
GIT_PROMPT_SUFFIX="%f%k"
GIT_PROMPT_AHEAD="%F{yellow}NUM⬆ %f"
GIT_PROMPT_BEHIND="%F{green}NUM⬇️ %f"
GIT_PROMPT_DELETED="%F{red}NUM◉ %f"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}Y%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%F{yellow}?%f"
GIT_PROMPT_MODIFIED="%F{blue}✱ %f"
GIT_PROMPT_STAGED="%F{green}✚ %f"


parse_git_branch() {
	(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

parse_git_state() {
	local added=0
	local deleted=0
	local modified=0
	local renamed=0
	local unmerged=0
	local untracked=0
	local dirty=0

	local status_cmd="git status --porcelain"
	while IFS=$'\n' read line; do
		[[ "$line" == ([ACDMT][\ MT]|[ACMT]D)\ * ]] && (( added++ ))
		[[ "$line" == [\ ACMRT]D\ * ]] && (( deleted++ ))
		[[ "$line" == ?[MT]\ * ]] && (( modified++ ))
		[[ "$line" == R?\ * ]] && (( renamed++ ))
		[[ "$line" == (AA|DD|U?|?U)\ * ]] && (( unmerged++ ))
		[[ "$line" == \?\?\ * ]] && (( untracked++ ))
		(( dirty++ ))
	done < <(${(z)status_cmd} 2> /dev/null)

	local GIT_STATE=''
	local ahead_and_behind_cmd='git rev-list --count --left-right HEAD...@{upstream}'
	local ahead_and_behind="$(${(z)ahead_and_behind_cmd} 2> /dev/null)"
	local ahead="$ahead_and_behind[(w)1]"
	local behind="$ahead_and_behind[(w)2]"

	if (( ahead > 0 )); then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$ahead}
	fi

	if (( behind > 0 )); then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$behind}
	fi

	if (( added > 0 )); then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_STAGED}
	fi

	if (( deleted > 0 )); then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_DELETED//NUM/$deleted}
	fi

	if (( modified > 0 )); then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_MODIFIED}
	fi

	if (( untracked > 0 )); then
		GIT_STATE=$GIT_STATE${GIT_PROMPT_UNTRACKED}
	fi

	if [[ -n $GIT_STATE ]]; then
		echo "$GIT_STATE"
	fi
}

git_prompt_string() {
	local git_where="$(parse_git_branch)"
	[ -n "$git_where" ] && echo "$GIT_PROMPT_PREFIX%F{magenta}${git_where#(refs/heads/|tags/)} $GIT_PROMPT_SYMBOLS$(parse_git_state)$GIT_PROMPT_SUFFIX"
}

RPS1='$(git_prompt_string)'

#RPS1=$GIT_PROMPT_STAGED
