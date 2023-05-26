function open --description 'Remotely open a for the current or given path.'

    set -f url false

    # Set the path if we have arguments.
    if test (count $argv) -gt 0
        set -f path $argv
    else
        # If this is a git repository, and we have git-open, open the remote URL.
        if type -q git-open
            set -f path (command git-open --print)
        else
            # Otherwise use the PWD if no arguments were passed.
            set -f path $PWD
        end
    end

    # Pass through URLs. TODO: Handle file:/// URLs?
    if string match -e -q "://" -- $path
        set -f remote $path
        set -f url true

    else if string match -e -q "-" -- $path
        # If run with a - option, pass it through to macOS open.
        command open $path
        return 0

    else if set -q SSH_TTY
        # Clean up the path.
        set -f path (string escape -n -- (realpath -- $path))

        if string match -q -r "^/bits" -- $path
            set -l partial (string replace /bits/ "" $path)
            set -f remote "~/Mounts/$hostname/$partial"

        else if string match -q -r "^$HOME" -- $path

            switch $OS
                case Darwin
                    set -f remote (string replace $HOME /home/$USER -- $path)
                case Linux
                    set -f remote (string replace $HOME /Users/$USER -- $path)
            end
        end
    end

    if not set -q remote
        set -f remote $path
    end

    if set -q SSH_TTY
        # https://github.com/superbrothers/opener
        if test -e $HOME/.opener.sock
            echo $remote | nc -U "$HOME/.opener.sock"
        else
            echo "Install opener: https://github.com/superbrothers/opener"
        end
    else
        if set -q url
            command open --background $remote
        else
            command open $remote
        end
    end
end
