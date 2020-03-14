function wip --wraps="git commit" -d "git commit wip"
    command git commit -m wip $argv
end
