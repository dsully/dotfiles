function gp --wraps="git pull" -d "git pull rebase"

    echo "Pulling with rebase and autostash ..."

    command git pull --rebase --autostash $argv

    if test $status -eq 0

        echo "Pruning local branches that have been merged ..."
        git prune-branches
    end
end
