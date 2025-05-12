function cd-up
    prevd; and commandline -f repaint
end

function cd-down
    # If no next item in forward history pick a new path.
    if test (count $dirnext) -eq 0
        set --local path $(fd -t d -d 2 . | fzf)
        and cd $path
        and commandline -f repaint
    else
        nextd; and commandline -f repaint
    end
end

# Function to print custom key bindings with descriptions
function print_custom_binds --description "Prints out custom user binds"
    set_color normal
    set_color --bold white
    echo
    echo Bindings
    echo
    set_color normal

    # Define the bindings data
    set -l bindings
    set -a bindings "Alt+C\tFuzzy search directories to cd into"
    set -a bindings "Ctrl+N\tNavigate down in directory tree"
    set -a bindings "Ctrl+O\tNavigate up in directory tree"
    set -a bindings "Ctrl+R\tFuzzy search command history"
    set -a bindings "Ctrl+T\tFuzzy search files in current directory"
    set -a bindings ",ff\tCustom file finder function"
    set -a bindings ",fg\tCustom file grep function"
    set -a bindings ",fr\tCustom file replace function"

    # Print each binding with colors
    for binding in $bindings
        set -l parts (string split "\t" $binding)
        set_color normal
        set_color --bold white
        printf "  * "
        set_color normal
        set_color cyan
        printf "%-8s " $parts[1]
        set_color white
        printf "%s\n" $parts[2]
    end

    set_color normal
    echo
end

function fish_user_key_bindings
    status is-interactive || exit

    bind \co cd-up
    bind \cn cd-down

    print_custom_binds
end
