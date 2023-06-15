function gr --wraps=git-review --description 'git review create'
    command git review create -o --no-amend --no-prompt $argv
end
