function ,fg
    set -l FZF_DEFAULT_COMMAND rg --column --line-number --no-binary --no-heading

    fzf \
        $PICKER_ARGS \
        --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true" \
        --bind "enter:clear-screen+become(nvim {1}:{2}:{3})" \
        --bind "start:reload:$FZF_DEFAULT_COMMAND '{q}'" \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --print-query $INITIAL_QUERY
end

# https://kau.sh/blog/magic-enter-shell/
function __magic_enter_fg
    set -l cmd (commandline)
    commandline -f repaint
    if test -z "$cmd"
        commandline -r (,fg)
        commandline -f suppress-autosuggestion
    end
    commandline -f execute
end

bind ,fg __magic_enter_fg
