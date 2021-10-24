# Patch the "alias" function to fix the problem of background jobs showing up as "aliased-command $argv".
if status is-interactive
    functions alias | while read line
        switch (string trim "$line")
            case 'echo "function $name $wraps --description $cmd_string; $prefix $body \$argv; end" | source'
                echo 'echo "function $name $wraps --description $cmd_string; eval (printf \"%s%s\" \"$prefix $body \" (printf \"%s \" (string escape -- \$argv))); end" | source'
            case '*'
                echo "$line"
        end
    end | source
end
