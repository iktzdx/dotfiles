#!/usr/bin/env bash

wait="& while [ : ]; do sleep 1; done"

langs=$(echo "golang lua bash" | tr ' ' '\n')
utils=$(echo "find file xargs sed awk" | tr ' ' '\n')

function parse_query {
    read -r -p "query: " query;
    query_string=${query// /+}
    echo "$query_string"
}

function curl_using_predefined_opts {
    selected=$(printf "%s\n%s" "$langs" "$utils" | fzf)

    if echo "$langs" | grep -q "$selected"; then
        tmux neww bash -c "curl cht.sh/$selected/$(parse_query) $wait"
    else
        read -r -p "query: " query
        tmux neww bash -c "curl cht.sh/$selected~$query $wait"
    fi
}

function curl_using_passed_opts {
    opt=$(printf "lang\nutil" | fzf --prompt "Programming language or core utils? ")

    if [ "$opt" == "lang" ]; then
        read -r -p "lang: " lang;
        tmux neww bash -c "curl cht.sh/$lang/$(parse_query) $wait";
        exit 0;
    fi

    if [ "$opt" == "util" ]; then
        read -r -p "util: " util;
        tmux neww bash -c "curl cht.sh/$util~$(parse_query) $wait";
        exit 0;
    fi
}

use_predefined=$(printf "yes\nno" | fzf --prompt "Use predefined options? ")

if [ "$use_predefined" == "yes" ]; then
    curl_using_predefined_opts;
fi

if [ "$use_predefined" == "no" ]; then
    curl_using_passed_opts;
fi
