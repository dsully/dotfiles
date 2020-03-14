function gru --wraps="git-review" -d "git review update"
    command git review update --update-desc $argv
end
