#!/usr/bin/env bash

NOTE_DIR="$HOME/Documents/Notes"
NOTE_FILE="TODO.md"
NOTE_PATH="$NOTE_DIR/$NOTE_FILE"

[[ ! -f "$NOTE_PATH" ]] && echo "# TODO List" > "$NOTE_PATH"

SESH=$(basename "$NOTE_PATH" | tr . _)

if [[ -z $TMUX ]]; then
    SWITCH_CMD="exit 0"
else
    CURRENT_SESH=$(tmux display-message -p '#S')
    SWITCH_CMD="tmux switch-client -t $CURRENT_SESH"
fi

NVIM_CMD="nvim $NOTE_PATH"
CMD="$NVIM_CMD && $SWITCH_CMD"

if ! tmux has-session -t "$SESH" 2> /dev/null; then
    tmux new-session -ds "$SESH" -c "$NOTE_DIR" "$CMD"
fi

if [[ -z $TMUX ]]; then
    tmux attach-session -t "$SESH"
else
    tmux switch-client -t "$SESH"
fi
