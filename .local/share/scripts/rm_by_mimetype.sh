#!/usr/bin/env bash

MIME_TYPES=(image video zip pdf)

PS3="Choose MIME-type: "
select type in "${MIME_TYPES[@]}"; do
    find . -maxdepth 1 -type f -exec file --mime-type {} + \
        | grep "$type" | cut -d: -f1 | tr '\n' '\0' \
        | xargs -0 rm -v;
    break
done
