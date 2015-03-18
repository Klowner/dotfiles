#!/bin/sh

for DIR in $(git submodule --quiet foreach git rev-parse --show-toplevel); do
    SCRIPT="$DIR/install.sh"
    if [ -e $SCRIPT ]; then
        (cd $DIR; './install.sh') &
    fi
done

