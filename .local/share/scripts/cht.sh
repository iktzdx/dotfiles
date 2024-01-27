#!/usr/bin/env bash

# Define a constant for the sleep command
WAIT_COMMAND="& while [ : ]; do sleep 1; done"

# Declare arrays of predefined programming languages and core utilities
LANGS=(golang lua bash)
UTILS=(find file xargs sed awk)

main() {
    local opts=(yes no exit)

    PS3="Use predefined options? "
    select option in "${opts[@]}"; do
        case $option in
            "yes") curl_predefined ;;
            "no") curl_manual ;;
            "exit") shutdown ;;
        esac
        break
    done
}

curl_predefined() {
    local opts=(back exit)

    PS3="Select a language or utility: "
    select selected in "${LANGS[@]}" "${UTILS[@]}" "${opts[@]}"; do
        case $selected in
            "back") main ;;
            "exit") shutdown ;;
            *) curl_chtsh "$selected";;
        esac
        break
    done
}

curl_chtsh() {
    local selected="$1"
    local query

    if [[ "${LANGS[*]}" =~ $selected ]]; then
        query="$(get_query_string)"
        curl_chtsh_lang "$selected" "$query"
    else
        query="$(get_query_string)"
        curl_chtsh_util "$selected" "$query"
    fi
}

curl_chtsh_lang() {
    local selected="$1"
    local query="$2"

    tmux neww bash -c "curl cht.sh/$selected/$query $WAIT_COMMAND"
    shutdown
}

curl_chtsh_util() {
    local selected="$1"
    local query="$2"

    tmux neww bash -c "curl cht.sh/$selected~$query $WAIT_COMMAND"
    shutdown
}

curl_manual() {
    local opts=(lang util back exit)

    PS3="Programming language or core utils? "
    select option in "${opts[@]}"; do
        case $option in
            "lang") curl_manual_lang ;;
            "util") curl_manual_util ;;
            "back") main ;;
            "exit") shutdown ;;
        esac
        break
    done
}

curl_manual_lang() {
    local query

    read -r -p "Programming language: " selected
    query="$(get_query_string)"

    curl_chtsh_lang "$selected" "$query"
}

curl_manual_util() {
    local query

    read -r -p "Core utility name: " selected
    query="$(get_query_string)"

    curl_chtsh_util "$selected" "$query"
}

get_query_string() {
    read -r -p "Search query: " query;
    query_string=${query// /+}
    echo "$query_string"
}

shutdown() {
    echo "Exiting with code 0"
    exit 0
}

main
