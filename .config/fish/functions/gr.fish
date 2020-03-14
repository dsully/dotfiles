function gr --wraps="git-review" -d "git review create"
    command git review create -o --no-prompt $argv
end
