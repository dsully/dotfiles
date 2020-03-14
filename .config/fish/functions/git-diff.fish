function git-diff --wraps="git diff"
    command git diff --relative $argv
end
