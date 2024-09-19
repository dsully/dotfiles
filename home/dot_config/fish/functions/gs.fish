function gs -d "git sync: fetch, autorebase and trim branches that have been merged."

    set current (command git branch --show-current)

    echo "Pulling ..."
    command git fetch --all --prune

    # Loop through all remotes and attempt fast-forward
    for r in (command git remote)
        do-ff $current $r
    end

    # Fast-forward the current branch if it has an upstream
    if test -n "$current"
        set upstream (command git branch --list --format "%(upstream:short)" "$current")
        if test -n "$upstream"
            echo "Fast-forward branch '$current' to '$upstream'"
            command git merge --ff-only "$upstream"; or true
        end
    end

    # if command -q autorebase
    #     echo "Pulling and autorebasing..."
    #     autorebase --include-non-local --slow
    # else
    #     echo "Pulling ..."
    #     git pull
    # end

    if test $status -eq 0

        if type -q git-trim
            echo "Pruning local branches that have been merged ..."
            git trim --no-confirm --no-update
        else
            echo "Install git-trim via 'cargo binstall -y git-trim'"
        end
    end
end

function do-ff
    set current $argv[1]
    set input_remote $argv[2]
    set -l local remote upstream

    git branch --list --format "%(refname:short):%(upstream:remotename):%(upstream:short)" | while read -l local remote upstream

        if test "$local" = "$current"
            continue
        end

        if test "$remote" != "$input_remote"
            continue
        end

        if test -z "$upstream"
            continue
        end

        if not git show-ref --quiet "$upstream"
            continue
        end

        if not git merge-base --is-ancestor "$local" "$upstream"
            echo "Not possible to fast-forward branch '$local' to '$upstream'"
            continue
        end

        git branch --force "$local" "$upstream"
    end
end
