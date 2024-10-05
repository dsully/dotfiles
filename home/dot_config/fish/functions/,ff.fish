function ,ff --description 'Find and open files with fzf'
    __fzf_picker_args

    # FZF_DEFAULT_COMMAND comes from conf.d/fzf.fish
    set -f fzf_args $PICKER_ARGS
    set -a fzf_args --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true"
    set -a fzf_args --preview "__fzf_preview_file_content --path {}"
    set -a fzf_args --print0

    set -l selected_files (command fzf $fzf_args | string split0)

    for s in $pipestatus
        if test $s -ne 0
            commandline --function repaint
            return $s
        end
    end

    # No files selected
    test (count $selected_files) -eq 0; and return 0

    commandline "nvim $selected_files"
end
