#!/usr/bin/env bash

declare -A MIME_TYPES=(
    ["image"]="^image/"
    ["video"]="^video/"
    ["archive"]="^(application\/x-tar|application\/x-7z-compressed|application\/x-xz|application\/x-rar-compressed|application\/zip|application\/gzip|application\/x-bzip2)"
    ["pdf"]="application/pdf"
)

PS3="Choose MIME-type: "
select type in "${!MIME_TYPES[@]}"; do
    regex=${MIME_TYPES[$type]}
    find . -maxdepth 1 -type f -exec file --mime-type {} \; \
        | awk -v regex="$regex" -F": " '$2 ~ regex { print $1 }' | tr '\n' '\0' \
        | xargs -0 rm -v
    break
done
