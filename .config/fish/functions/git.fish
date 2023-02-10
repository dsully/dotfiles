function git --wraps=git --description 'Wrapper to handle git main/master'

    set -f MAIN main
    set -f MASTER master
    set -f GIT git

    # Check with git so that "main" gets rewritten to "master" if that's the default branch, or vice versa.
    set -f branch (command $GIT symbolic-ref -q refs/remotes/origin/HEAD|string split -f 4 "/")

    if test -n $branch

        for i in (seq (count $argv))

            if test "$branch" = $MASTER; and string match -q $MAIN -- $argv[$i]
                set argv[$i] (string replace -r "\b$MAIN\b" $MASTER -- $argv[$i])
            else if test "$branch" = $MAIN; and string match -q $MASTER -- $argv[$i]
                set argv[$i] (string replace -r "\b$MASTER\b" $MAIN -- $argv[$i])
            end
        end
    end

    # https://github.com/nguyenvukhang/gitnu
    # This is removing color output right now.
    # if type -q gitnu
    #     set -f GIT gitnu
    # end

    command $GIT $argv
end
