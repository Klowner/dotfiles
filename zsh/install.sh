#!/bin/zsh

if [[ -d "$HOME/.dotfiles/zsh/prezto" ]]; then
    OVERRIDES="$HOME/.dotfiles/zsh/prezto-override"

    ln -nfs "$HOME/.dotfiles/zsh/prezto" "${ZDOTDIR:-$HOME}/.zprezto"

    # Symlink all prezto scripts, unless they exist in prezto-override.
    # If they are in prezto-override, link those instead
    for rcfile in "$HOME"/.dotfiles/zsh/prezto/runcoms/z*; do
        if [[ ! -e "$OVERRIDES/${rcfile:t}" ]]; then
            ln -nfs "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        else
            ln -nfs "$OVERRIDES/${rcfile:t}" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        fi
    done
fi

