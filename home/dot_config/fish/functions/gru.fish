function gru --wraps=git-review --description 'git review update'
    command git review update --update-desc --no-amend $argv
end
