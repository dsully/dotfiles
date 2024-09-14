function ,ff --description 'Find and open files with fzf'

    set -l FZF_DEFAULT_COMMAND rg --files --hidden --no-binary --sort=path

    fzf \
        $PICKER_ARGS \
        --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true" \
        --bind "enter:clear-screen+become(nvim {+})" \
        --preview "_fzf_preview_file {}"
end

# https://kau.sh/blog/magic-enter-shell/
function __magic_enter_fg
    set -l cmd (commandline)
    commandline -f repaint
    if test -z "$cmd"
        commandline -r (,ff)
        commandline -f suppress-autosuggestion
    end
    commandline -f execute
end

bind ,ff __magic_enter_ff
