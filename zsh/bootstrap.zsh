[[ -z $ANTIGEN ]] && echo 'export ANTIGEN=(path to antigen)' && return 1

# Tab completion
zstyle ':completion:*' format ''
zstyle ':completion:*' menu select auto

# Load Antigen
source $ANTIGEN/antigen.zsh

# Load Antigen config
source $ZSH_CUSTOM/antigen.zsh

# Load aliases
source $ZSH_CUSTOM/aliases.zsh

# Load extras
source $ZSH_CUSTOM/extras.zsh


