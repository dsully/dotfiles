function git --wraps=git --description 'Wrapper to handle git main/master'

    set -f MAIN main
    set -f MASTER master

    # Check with git so that "main" gets rewritten to "master" if that's the default branch, or vice versa.
    set -f branch (command git symbolic-ref -q refs/remotes/origin/HEAD|string split -q -f 4 "/")

    if test -n $branch

        for i in (seq (count $argv))

            if test "$branch" = $MASTER; and string match -q $MAIN -- $argv[$i]
                set argv[$i] (string replace -r "\b$MAIN\b" $MASTER -- $argv[$i])
            else if test "$branch" = $MAIN; and string match -q $MASTER -- $argv[$i]
                set argv[$i] (string replace -r "\b$MASTER\b" $MAIN -- $argv[$i])
            end
        end
    end

    command git $argv
end
