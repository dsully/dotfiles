# Converted from gib's repo to fish.

# Default remote names
set -q REMOTE_PRIMARY_NAME; or set REMOTE_PRIMARY_NAME upstream
set -q REMOTE_FORK_NAME; or set REMOTE_FORK_NAME forked

function usage
    echo (set_color --bold blue)"$argv[1] [-h|--help] branch_name [git switch args...]"(set_color normal)
    echo ""
    echo "git sw: switch to a branch, or create it, setting the upstream tracking everything correctly."
    echo ""
    echo "If you specify an existing remote branch, then we check it out in detached mode."
    echo "If you don't specify a branch, we check out the default branch of the default remote."
    echo ""
    echo "ENVIRONMENT VARIABLES:"
    echo ""
    echo "REMOTE_PRIMARY_NAME:"
    echo "    Name of the default remote. Usually the upstream remote vs a forked remote."
    echo "    Default: $REMOTE_PRIMARY_NAME"
    echo ""
    echo "REMOTE_FORK_NAME:"
    echo "    Name of the forked remote (fork of the primary remote). Also applied as a prefix to"
    echo "    any forks of a non-primary remote. e.g. the fork of 'pub' would be 'pub-$REMOTE_FORK_NAME'."
    echo "    Default: $REMOTE_FORK_NAME"
end

# Works out the up remote for the specified fork remote
function upstream_remote_for_fork
    if test "$argv[1]" = "$REMOTE_FORK_NAME"
        echo $REMOTE_PRIMARY_NAME
    else
        echo (string replace -r "-$REMOTE_FORK_NAME\$" "" "$argv[1]")
    end
end

# Default branch for remote. `default_branch upstream` -> upstream/main
function default_remote_branch
    command git symbolic-ref --short refs/remotes/$argv[1]/HEAD 2>/dev/null; or begin
        command git remote set-head --auto $argv[1]
        command git symbolic-ref --short refs/remotes/$argv[1]/HEAD
    end
end

# Get upstream remote for current branch
function upstream_remote_for_current_branch
    command git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null | string split -f1 /
end

function git-sw --description "Switch to a branch, or create it, setting the upstream tracking everything correctly."

    # Handle help and version flags
    if test (count $argv) -gt 0; and string match -q -r "^(--help|-h)\$" -- $argv[1]
        usage $argv[1]
        return 0
    end

    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo (set_color red)"Error:"(set_color normal)" Not in a git repository" >&2
        return 1
    end

    if test (count $argv) -gt 0; and string match -q -r "^(--version|-v)\$" -- $argv[1]
        echo main
        return 0
    end

    # If --detach passed, just run the command directly
    if contains -- -d $argv; or contains -- --detach $argv
        command git switch $argv
        return 0
    end

    # Find the branch argument (last argument that doesn't start with -)
    set git_branch_arg ""

    for arg in $argv
        if not string match -q -r "^-" -- $arg
            set git_branch_arg $arg
        end
    end

    # `git sw` by itself checks out the default branch of the default remote
    if test (count $argv) -eq 0
        set remote_branch (default_remote_branch $REMOTE_PRIMARY_NAME)
        git switch (string replace -r "^[^/]+/" "" $remote_branch)
        return 0
    end

    # Count local branches before any operations
    set local_branch_count (command git branch --list --no-color | wc -l | string trim)

    # Handle different branch switching scenarios
    set -e created

    if contains -- -c $argv; or contains -- --create $argv; or contains -- -C $argv; or contains -- --force-create $argv
        # We're explicitly trying to create a new branch
        set -g created 1
        command git switch $argv

    else if test -z "$git_branch_arg"
        # Didn't find a branch name (e.g. `git sw -`), just run the switch
        command git switch $argv

    else if test (command git branch --no-color --list "$git_branch_arg" | string trim) -eq 0
        # We're trying to switch to an existing local branch
        command git switch $argv

    else if test (command git branch --all --no-color --list "$git_branch_arg" | string trim) -eq 0
        # User is specifying a remote branch directly, switch in detached mode
        command git switch -d $argv

    else if test (command git branch --all --no-color --list "*/$git_branch_arg" | string trim) -eq 0
        # Branch exists in a remote but not locally
        set -g created 1

        command git switch $argv
    else
        # Branch doesn't exist locally or remotely, create it
        command git switch -c $argv
    end

    # Check if we created a new branch by comparing branch counts
    if test $local_branch_count -ne (command git branch --list --no-color | wc -l | string trim)
        set -g created 1
    end

    # If we just created the branch and it's based on a fork branch, update upstream
    if set -q created
        set upstream_remote (upstream_remote_for_current_branch; or echo $REMOTE_FORK_NAME)

        if string match -q "*$REMOTE_FORK_NAME*" -- $upstream_remote
            set new_upstream_remote (upstream_remote_for_fork $upstream_remote)

            command git branch -u (default_remote_branch $new_upstream_remote)
        end
    end
end
