function __fzf_picker_args
    # Default arguments for file and grep pickers.
    set -gx PICKER_ARGS --ansi \
        --bind "ctrl-/:toggle-preview" \
        --bind "ctrl-a:select-all" \
        --bind "ctrl-d:deselect-all" \
        --bind "ctrl-k:preview-half-page-up" \
        --bind "ctrl-j:preview-half-page-down" \
        --bind "ctrl-r:toggle-sort" \
        --bind "ctrl-y:execute-silent(echo -n {} | pbcopy)+clear-screen+abort" \
        --bind "ctrl-z:ignore" \
        --border=sharp \
        --cycle \
        --exit-0 \
        --height=100% \
        --info=default \
        --layout=reverse-list \
        --margin=5% \
        --multi \
        --no-clear \
        --no-scrollbar \
        --preview-window 'up,50%,wrap,border-bottom,+{2}/3' \
        --select-1
end
