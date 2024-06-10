function clip --description "Copy files to clipboard"
    set contents ""

    for file in $argv
        if test (command file $file | command grep -c -E "text|JSON") -eq 1
            set contents "$contents\n" (command cat "$file")
            echo "Contents of $file are added to the clipboard buffer."
        else
            echo "File \"$file\" is not plain text."
        end
    end

    if test -n "$contents"
        echo -n $contents | command pbcopy
        echo "All valid file contents are now in the clipboard."
    else
        echo "No valid files to copy to the clipboard."
    end
end
