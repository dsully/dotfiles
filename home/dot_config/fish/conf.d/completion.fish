if status is-interactive

    # Exclude lock files from completion
    function __fish_complete_no_locks
        set -l token (commandline -ct)
        __fish_complete_suffix "$token" "" | string match -v '*.lock'
    end

    complete -c vi -f -a '(__fish_complete_no_locks)'
    complete -c vim -f -a '(__fish_complete_no_locks)'
    complete -c nvim -f -a '(__fish_complete_no_locks)'
    complete -c cat -f -a '(__fish_complete_no_locks)'
end
