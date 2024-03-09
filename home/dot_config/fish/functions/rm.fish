function rm --wraps=rip --description 'Safe remove'
    if type -q rip
        # Check if the first argument is "-r" or "-rf" and remove it if it matches
        if string match -q -e -- "^-r*" $argv[1]
            set -e argv[1]
        end

        # Call `rip` with the potentially modified arguments
        command rip $argv
    else
        # Fallback to regular `rm` if `rip` is not available
        command rm $argv
    end
end
