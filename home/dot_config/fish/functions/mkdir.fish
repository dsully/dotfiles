function mkdir --wraps mkdir -d "Create a directory and cd into it"
    command mkdir -p $argv
end
