#!/usr/bin/env bash

function main() {
    if [[ -z "$1" ]]; then
        cat <&0 > /dev/clipboard
        exit 0
    fi

    local file
    for file in "$@"; do
        [[ -f "$file" ]] || continue

        if [[ "$(uname)" == CYGWIN* ]]; then
            cat "$1" > /dev/clipboard
        fi
    done
}

main "$@"
