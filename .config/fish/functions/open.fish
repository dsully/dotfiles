function ropen --description 'Remotely open a Finder window for the current or given path.'

    if not set -q SSH_TTY
        command /usr/bin/open $argv
        exit 0
    end

    set -f ROPEN "$HOME/.ssh/ropen.txt"

    if not test -f $ROPEN
        echo "$ROPEN must exist."
        exit 0
    end

    set -f host (cat $ROPEN)
    set -f path $PWD

    argparse host -- $argv

    if set -q _flag_host
        set host $_flag_host
    end

    if test (count $argv) -gt 0
        if not string match "." $argv[1]
            set path $argv
        end
    end

    # Clean up the path.
    set -f path (string escape -n (realpath $path))

    if not string match -q -r "^/bits" $path
        echo "Can't open non /bits paths remotely."
        exit 1
    end

    set -f partial (string replace /bits/ "" $path)
    set -f remote "~/Mounts/$hostname/$partial"

    echo "Opening $remote on $host ..."
    command ssh $host /usr/bin/open $remote
end
