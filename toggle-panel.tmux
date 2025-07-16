#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default key binding
default_key_binding="\\"

# Get user's custom key binding or use default
key_binding=$(tmux show-option -gqv @toggle-panel-key)
key_binding=${key_binding:-$default_key_binding}

# Set up the key binding
tmux bind-key "$key_binding" run-shell "$CURRENT_DIR/toggle-panel.sh"
