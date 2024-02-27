function clip --description "Copy file to clipboard"

    if test (command file $argv | command grep -c -E "text|JSON") -eq 1
        command cat "$argv" | command pbcopy
        echo "Contents of $argv are in the clipboard."
        return 0
    end

    echo "File \"$argv\" is not plain text."
    return 1
end
