function __fzf_grep --description 'Ripgrep and open files with fzf'
    argparse 'q/query=' 't/type=' -- $argv

    __fzf_picker_args

    set -f FZF_DEFAULT_COMMAND rg --column --line-number --no-binary --no-heading --sort=path
    set -f fzf_args $PICKER_ARGS

    set -a fzf_args --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true"
    set -a fzf_args --bind "start:reload:$FZF_DEFAULT_COMMAND '{q}'"
    set -a fzf_args --delimiter :
    set -a fzf_args --preview "__fzf_preview_file_content --path {1} --line {2} --column {3}"
    set -a fzf_args --print0
    set -a fzf_args --no-sort

    if test -n "$_flag_type"
        set -a FZF_DEFAULT_COMMAND --type $_flag_type
    end

    if test -n "$_flag_query"
        set -a FZF_DEFAULT_COMMAND $_flag_query
    end

    set -l selected_files (command fzf $fzf_args | string split0)

    for s in $pipestatus
        if test $s -ne 0
            commandline --function repaint
            return $s
        end
    end

    # No files selected
    test (count $selected_files) -eq 0; and return 0

    set -l filenames

    for element in $selected_files
        set -l parts (string split -f 1,2,3 -- ':' $element)
        set -l file $parts[1]
        set -l line $parts[2]
        set -l column $parts[3]

        set -a filenames "$file:$line:$column"
    end

    commandline "nvim $filenames"
end
