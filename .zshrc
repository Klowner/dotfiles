HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.config/zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# Antigen git submodule in my dotfiles repo
export ANTIGEN=~/.dotfiles/antigen

[[ -z $ZSH_CUSTOM ]] && ZSH_CUSTOM=$(dirname $(readlink -f ~/.zshrc))/zsh
source $ZSH_CUSTOM/bootstrap.zsh

export EDITOR='vim'
export GIT_EDITOR=vim
export VISUAL=vim
export EDITOR=vim

export XDG_CONFIG_HOME=~/.config

