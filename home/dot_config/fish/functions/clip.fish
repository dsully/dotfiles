function clip --description "Copy files to clipboard" --wraps cat
    command cat $argv | fish_clipboard_copy
end
