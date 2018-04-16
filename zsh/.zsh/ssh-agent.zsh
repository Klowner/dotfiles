typeset _agent_forwarding _ssh_env_cache

function _start_agent {
	local lifetime
	local -a identities

	ssh-agent -s | sed 's/^echo/#echo/' >! $_ssh_env_cache
	. $_ssh_env_cache > /dev/null

	zstyle -a :ssh-agent identities identities
	echo starting ssh-agent...
	ssh-add $HOME/.ssh/${^identities}
}

_ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

# Add symlink for screen/tmux for agent forwarding
if [[ "$SSH_AUTH_SOCK" ]]; then
	[[ -L $SSH_AUTH_SOCK ]] || ln -s "$SSH_AUTH_SOCK" /tmp/user-agent-$USER-screen
elif [[ -f "$_ssh_env_cache" ]]; then
	. $_ssh_env_cache > /dev/null
	ps x | grep ssh-agent | grep -q $SSH_AGENT_PID || {
		_start_agent
	}
else
	_start_agent
fi

unset _agent_forwarding _ssh_
unfunction _start_agent

