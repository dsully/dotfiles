function open --description 'Remotely open a for the current or given path.'

    if not set -q SSH_TTY
        command open $argv
        return 0
    end

    # Set the path if we have arguments.
    if test (count $argv) -gt 0
        set -f path $argv
    else
        # If this is a git repository, and we have git-open, open the remote URL.
        if type -q git-open
            command git-open
            return 0
        end

        # Otherwise use the PWD if no arguments were passed.
        set -f path $PWD
    end

    # Pass through URLs. TODO: Handle file:/// URLs?
    if string match -q -r "://" $path
        set -f remote $path

    else
        # Clean up the path.
        set -f path (string escape -n (realpath $path))

        if string match -q -r "^/bits" $path
            set -l partial (string replace /bits/ "" $path)
            set -f remote "~/Mounts/$hostname/$partial"

        else if string match -q -r "^$HOME" $path

            switch $OS
                case Darwin
                    set -f remote (string replace $HOME /home/$USER $path)
                case Linux
                    set -f remote (string replace $HOME /Users/$USER $path)
            end
        end
    end

    # https://github.com/superbrothers/opener
    if test -e $HOME/.opener.sock
        echo $remote | nc -U "$HOME/.opener.sock"
    else
        echo "Install opener: https://github.com/superbrothers/opener"
    end
end
