function gd --wraps="git diff"
    command git diff --relative $argv
end
