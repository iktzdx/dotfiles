#!/usr/bin/env bash

types=$(echo "image video pdf zip" | tr ' ' '\n')

selected=$(echo "$types" | fzf)

find . -maxdepth 1 -type f -exec file --mime-type {} + \
    | grep "$selected" | cut -d: -f1 | tr '\n' '\0' \
    | xargs -0 rm -v
