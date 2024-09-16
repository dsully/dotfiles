function ,ff --description 'Find and open files with fzf'

    # FZF_DEFAULT_COMMAND comes from conf.d/fzf.fish
    fzf \
        $PICKER_ARGS \
        --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true" \
        --bind 'enter:become(''nvim {} > "$(command tty)")' \
        --preview "_fzf_preview_file {+}"
end
