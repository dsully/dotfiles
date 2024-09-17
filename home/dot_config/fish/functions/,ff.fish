function ,ff --description 'Find and open files with fzf'

    # FZF_DEFAULT_COMMAND comes from conf.d/fzf.fish
    fzf \
        $PICKER_ARGS \
        --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true" \
        --bind 'enter:execute(''nvim {+} > "$(command tty)")' \
        --preview "_preview_file_content --path {}"
end
