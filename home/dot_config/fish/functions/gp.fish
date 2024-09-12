function gp -d "git pull and autorebase and trim branches that have been merged"

    set current (git branch --show-current)

    if command -q autorebase
        echo "Pulling and autorebasing onto '$current' branch..."
        autorebase --include-non-local --slow --onto $current
    else
        echo "Pulling ..."
        git pull
    end

    if test $status -eq 0

        if type -q git-trim
            echo "Pruning local branches that have been merged ..."
            git trim --no-update
        else
            echo "Install git-trim via 'cargo binstall -y git-trim'"
        end
    end
end
