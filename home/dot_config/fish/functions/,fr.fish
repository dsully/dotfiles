function ,fr --description 'Fuzzy search and cd to a Git repository in ghq' --wraps ghq
    __fzf_picker_args

    set -l query (commandline -b)

    [ -n "$query" ]; and set flags --query="$query"; or set flags

    command ghq list --full-path | fzf $PICKER_ARGS --tiebreak=index $flags | read select

    [ -n "$select" ]; and cd "$select"

    commandline -f repaint
end
