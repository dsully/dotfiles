function ,ft --description 'Fuzzy search for files of a specific type'

    if test (count $argv) -lt 2
        echo "Usage: ,ft <filetype> <query>"
        return 1
    end

    __fzf_picker_args
    __fzf_grep --type $argv[1] --query "$argv[2..]"
end
