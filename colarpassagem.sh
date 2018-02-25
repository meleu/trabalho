#!/usr/bin/env bash

#file="/PATH/TO/FILE.txt"

function main() {
    [[ -z "$file" ]] && exit 1
    # ignoring case sensitiveness on file names
    shopt -s nocaseglob

    local date="$(head -1 "$file" | tr -d '\r')"
    local name="$(sed -n 2p "$file" | tr -d '\r')"
    local text
    local final_text
    
    prevline=
    while read -r line; do
        if [[ -n "$line" ]]; then
            [[ -z "$prevline" ]] && text+="$date\t$name\t\t\t\""
            text+="$line\n"
        else
            [[ -n "$prevline" ]] && text+="\"\n"
        fi
        prevline="$line"
    done < <(tail +3 "$file" | tr -d '\r')

    prevline=
    while read -r line; do
        if [[ "$prevline" != "\"" && -n "$prevline" ]]; then
            if [[ "$line" == "\"" ]]; then
                final_text+="$prevline\"\n"
            else
                final_text+="$prevline\n"
            fi
        fi
        prevline="$line"
    done < <(echo -en "$text")
    echo -ne "$final_text"
}

main "$@"
