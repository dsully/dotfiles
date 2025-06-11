function clean_rm_flags
    set -l cleaned

    for arg in $argv
        if string match -q -- "--version" $arg
            echo $arg
            return
        end

        # Skip recursive and force flags in various forms
        if string match -q -- -r $arg; or string match -q -- -f $arg; or string match -q -- -rf $arg; or string match -q -- -fr $arg
            continue

            # Handle other flags that might contain r or f
        else if string match -q -- "-*" $arg
            # Check if the flag contains 'r' or 'f'
            set cleaned_flag (string replace -r -a '[rf]' '' -- $arg)

            # set cleaned_flag (string replace -a "r" "" (string replace -a "f" "" $arg))

            # If the cleaned flag is different from the original and not just a hyphen
            if test "$cleaned_flag" != "$arg" -a "$cleaned_flag" != -
                set -a cleaned $cleaned_flag

            else if test "$cleaned_flag" = -
                # Skip if only r and f were in the flag
                continue
            else
                # Keep the flag as is
                set -a cleaned $arg
            end
        else
            # Add non-flag arguments as is
            set -a cleaned $arg
        end
    end

    if test -z "$cleaned"
        echo "Error: cleaned argv is empty! Original: [$argv]" >&2
        exit 1
    end

    echo $cleaned
end

function rm --wraps rip
    if type -q rip

        for path in (string split " " -- (clean_rm_flags $argv))
            command rip $path
        end

    else if type -q gomi

        command gomi $argv
    else
        /bin/rm $argv
    end
end
