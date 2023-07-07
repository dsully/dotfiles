function open --description 'Remotely open a for the current or given path.'

    set -f url false

    # Set the path if we have arguments.
    if test (count $argv) -gt 0
        set -f path $argv
    else
        # If this is a git repository, and we have git-open, open the remote URL.
        # Call with --print otherwise this doesn't work when running via SSH as I want --background
        set -l git (command git rev-parse --show-toplevel >/dev/null 2>&1)

        if test $status -eq 0; and type -q git-open
            set -f path (command git-open --print $git)
        else
            # Otherwise use the PWD if no arguments were passed.
            set -f path $PWD
        end
    end

    # Pass through URLs. TODO: Handle file:/// URLs?
    if string match -e -q "://" -- $path
        set -f remote $path
        set -f url true

    else if string match -e -q - -- $path
        # If run with a - option, pass it through to macOS open.
        if string match -q -r "\-\-help" -- $path
            command open -h
        else
            command open $path
        end

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
        # brew install xdg-open-svc, runs on this port.
        echo "$remote" | nc -q1 localhost 2226
    else
        if $url = true
            command open --background $remote
        else
            command open $remote
        end
    end
end
