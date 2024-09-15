function ,fg --description 'Ripgrep and open files with fzf'

    set -l FZF_DEFAULT_COMMAND rg --column --line-number --no-binary --no-heading

    fzf \
        $PICKER_ARGS \
        --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true" \
        --bind "enter:clear-screen+become(nvim {1}:{2}:{3})" \
        --bind "start:reload:$FZF_DEFAULT_COMMAND '{q}'" \
        --delimiter : \
        --preview "fzf_preview_file_cmd {+}" \
        --print-query $INITIAL_QUERY
end
