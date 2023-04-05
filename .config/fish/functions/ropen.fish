function ropen --description 'Remotely open a Finder window for the current or given path.'

    set -f host (cat "$HOME/.ssh/ropen.txt")
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
