# vim:set ft=zsh:

source ~/.config/user-dirs.dirs

## Options
setopt correct                  # Auto correct mistakes
setopt extendedglob             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob               # Case insensitive globbing
setopt rcexpandparam            # Array expansion with parameters
setopt nocheckjobs              # Don't warn about running processes when exiting
setopt numericglobsort          # Sort filenames numerically when it makes sense
setopt nobeep                   # No beep
setopt appendhistory            # Immediately append history instead of overwriting
setopt histignorealldups        # If a new command is a duplicate, remove the older one
setopt autocd                   # If only directory path is entered, cd there.
setopt inc_append_history       # Save commands are added to the history immediately, otherwise only when shell exits.
setopt histignorespace          # Don't save commands that start with space
setopt extended_history         # Include extra info about executed commands
setopt hist_reduce_blanks       # Reduce blanks from commands in history

zstyle ':completion:*' rehash true   # Automatically find new executables in path
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ${XDG_CACHE_DIR:-~/.cache}/zsh
HISTFILE=${XDG_CACHE_DIR:-~/.cache}/.zhistory
HISTSIZE=50000
SAVEHIST=50000

# Additional configuration files
[ -d "${ZDOTDIR}/config.d/" ] && source <(cat ${ZDOTDIR}/config.d/*)

# Host specific config
[ -f "${ZDOTDIR}/zshrc.${HOST}" ] && source "${ZDOTDIR}/zshrc.${HOST}"

# Optional local config
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

