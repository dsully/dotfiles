function rm --wraps=rip --description 'Safe remove'
    if command -q rip
        set processed_args

        for arg in $argv
            if not echo $arg | grep -q -E '^-r$|^-rf$|^-f$'
                set processed_args $processed_args $arg
            end
        end

        # Call `rip` with the potentially modified arguments
        command rip $processed_args
    else
        # Fallback to regular `rm` if `rip` is not available
        command rm $argv
    end
end
