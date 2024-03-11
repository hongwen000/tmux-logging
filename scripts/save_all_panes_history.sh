#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

main() {
        if supported_tmux_version_ok; then
                local window_index="$(tmux display-message -p '#{window_index}')"
                local pane_indexes="$(tmux list-panes -F '#{pane_index}' -t ":$window_index")"

                for pane_index in $pane_indexes; do
                        local file=$(expand_tmux_format_path "${save_complete_history_path}/tmux-history-#{session_name}-#{window_index}-$pane_index-%Y%m%dT%H%M%S.log")
                        local history_limit="$(tmux display-message -p -F "#{history_limit}" -t ":$window_index.$pane_index")"
                        tmux capture-pane -J -S "-${history_limit}" -p -t ":$window_index.$pane_index" > "${file}"
                        remove_empty_lines_from_end_of_file "${file}"
                done

                display_message "History of all panes saved to ${save_complete_history_path}"
        fi
}
main
