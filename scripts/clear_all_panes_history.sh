#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

main() {
        if supported_tmux_version_ok; then
                local window_index="$(tmux display-message -p '#{window_index}')"
                local pane_indexes="$(tmux list-panes -F '#{pane_index}' -t ":$window_index")"

                for pane_index in $pane_indexes; do
                        tmux clear-history -t ":$window_index.$pane_index"
                done

                display_message "Scroll back history of all panes cleared!"
        fi
}
main
