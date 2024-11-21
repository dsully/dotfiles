function clip --description "Copy files to clipboard"
    /bin/cat $argv | pbcopy
end
