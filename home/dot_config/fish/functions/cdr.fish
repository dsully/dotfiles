function cdr --description "chdir to the root of a git repo."
    set -l repo (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD 2> /dev/null)
    test -n "$repo"; or return

    set -l cd_up_path (command git rev-parse --show-cdup)

    if test -n $cd_up_path
        cd $cd_up_path
    end
end
