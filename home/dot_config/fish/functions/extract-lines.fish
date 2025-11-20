function extract-lines -d "Extract lines from first to last line number"
    if test (count $argv) -ne 3
        echo "Usage: extract_lines <first_line> <last_line> <input_file>" >&2
        return 1
    end

    set first_line $argv[1]
    set last_line $argv[2]
    set input_file $argv[3]

    # https://stackoverflow.com/questions/83329/how-can-i-extract-a-predetermined-range-of-lines-from-a-text-file-on-unix
    sed -n "$first_line,\$p;$last_line q" $input_file
end
