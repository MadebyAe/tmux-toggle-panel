#!/usr/bin/env bash
set -euo pipefail

# Configuration
HIDDEN_WINDOW_NAME="hidden_panel"
DEFAULT_WIDTH_PERCENT=25

# Get saved width or use default
SAVED_WIDTH=$(tmux show-option -gqv @toggle-panel-width)
WIDTH_EXPANDED_PERCENT=${SAVED_WIDTH:-$DEFAULT_WIDTH_PERCENT}

# Check if hidden window exists
HIDDEN_WINDOW=$(tmux list-windows -F "#{window_name}" | grep "^$HIDDEN_WINDOW_NAME$" || echo "")

if [ -n "$HIDDEN_WINDOW" ]; then
    # Hidden window exists, join it back as a pane
    WINDOW_WIDTH=$(tmux display-message -p "#{window_width}")
    WIDTH_EXPANDED=$((WINDOW_WIDTH * WIDTH_EXPANDED_PERCENT / 100))

    # Join the hidden window as a pane on the right
    tmux join-pane -h -l "$WIDTH_EXPANDED" -s "$HIDDEN_WINDOW_NAME"
else
    # Check number of panes in current window
    PANE_COUNT=$(tmux list-panes | wc -l)

    if [ "$PANE_COUNT" -eq 1 ]; then
        # Only one pane exists, create a new one as sidebar
        WINDOW_WIDTH=$(tmux display-message -p "#{window_width}")
        WIDTH_EXPANDED=$((WINDOW_WIDTH * WIDTH_EXPANDED_PERCENT / 100))

        # Create new pane on the right with empty shell
        tmux split-window -h -l "$WIDTH_EXPANDED"

        # Break the new pane into hidden window
        PANE=$(tmux list-panes -F "#{pane_id}" | tail -1)
        tmux break-pane -d -s "$PANE" -n "$HIDDEN_WINDOW_NAME"
    else
        # Find rightmost pane and break it into a hidden window
        PANE=$(tmux list-panes -F "#{pane_id} #{pane_right}" | sort -k2 -nr | head -1 | cut -d' ' -f1)

        # Check if current width differs from default (user manually resized)
        CURRENT_PANE_WIDTH=$(tmux list-panes -F "#{pane_id} #{pane_width}" | grep "^$PANE " | cut -d' ' -f2)
        WINDOW_WIDTH=$(tmux display-message -p "#{window_width}")
        CURRENT_WIDTH_PERCENT=$((CURRENT_PANE_WIDTH * 100 / WINDOW_WIDTH))

        # Save width if user manually resized (differs from default by more than 2%)
        if [ $((CURRENT_WIDTH_PERCENT - DEFAULT_WIDTH_PERCENT)) -gt 2 ] || [ $((DEFAULT_WIDTH_PERCENT - CURRENT_WIDTH_PERCENT)) -gt 2 ]; then
            tmux set-option -g @toggle-panel-width "$CURRENT_WIDTH_PERCENT"
        fi

        # Break the pane into a new window
        tmux break-pane -d -s "$PANE" -n "$HIDDEN_WINDOW_NAME"
    fi
fi
