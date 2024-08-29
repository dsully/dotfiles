function arb -d "git pull and autorebase"

    autorebase --include-non-local --slow

    if test $status -eq 0
        echo "Pruning local branches that have been merged ..."
        git prune-branches
    end
end
