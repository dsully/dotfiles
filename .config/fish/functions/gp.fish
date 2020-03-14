function gp --wraps="git pull" -d "git pull rebase"
    command git pull --rebase $argv
end
