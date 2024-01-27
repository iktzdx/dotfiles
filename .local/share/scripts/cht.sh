#!/usr/bin/env bash

wait="& while [ : ]; do sleep 1; done"
langs=$(echo "golang lua bash" | tr ' ' '\n')
utils=$(echo "find file xargs sed awk" | tr ' ' '\n')

main() {
    use_predefined=$(printf "yes\nno" | fzf --prompt "Use predefined options? ")
    [ "$use_predefined" == "yes" ] && curl_predefined || curl_manual
}

curl_predefined() {
    selected=$(printf "%s\n%s" "$langs" "$utils" | fzf)
    echo "$langs" | grep -qs "$selected" && curl_chtsh_lang || curl_chtsh_util
}

curl_chtsh_lang() {
    tmux neww bash -c "curl cht.sh/$selected/$(get_query_string) $wait"
}

curl_chtsh_util() {
    tmux neww bash -c "curl cht.sh/$selected~$(get_query_string) $wait"
}

curl_manual() {
    opt=$(printf "lang\nutil" | fzf --prompt "Programming language or core utils? ")
    [ "$opt" == "lang" ] && curl_manual_lang || curl_manual_util
}

curl_manual_lang() {
    read -r -p "lang: " selected
    curl_chtsh_lang
    exit 0
}

curl_manual_util() {
    read -r -p "util: " selected
    curl_chtsh_util
    exit 0
}

get_query_string() {
    read -r -p "query: " query;
    query_string=${query// /+}
    echo "$query_string"
}

main
