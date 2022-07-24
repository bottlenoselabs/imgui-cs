#!/bin/bash
DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if [[ -z $SCRIPTS_DIRECTORY ]]; then
    SCRIPTS_DIRECTORY="$DIRECTORY/ext/scripts"
    git clone "https://github.com/bottlenoselabs/scripts" "$SCRIPTS_DIRECTORY" 2> /dev/null 1> /dev/null || git -C "$SCRIPTS_DIRECTORY" pull 1> /dev/null
fi

$DIRECTORY/ext/scripts/c/library/main.sh \
    $DIRECTORY/ext/cimgui \
    $DIRECTORY/build \
    $DIRECTORY/lib \
    "cimgui" \
    "cimgui" \
    "" \
    "" \