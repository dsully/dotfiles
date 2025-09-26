function rm --wraps rip
    set -l cmd /bin/rm
    set -l options

    if type -q trash
        set cmd trash
    elif type -q rip
        set cmd rip
    else if type -q gomi
        set cmd gomi
    end

    if string match -q -- /bin/rm $cmd
        /bin/rm $argv
        return
    end

    for arg in $argv

        if string match -q -- --version $arg
            $cmd $arg
            return
        end

        # Skip recursive and force flags in various forms
        if string match -q -- -r $arg; or string match -q -- -f $arg; or string match -q -- -rf $arg; or string match -q -- -fr $arg
            continue
        end

        set -a options $arg
    end

    $cmd $options
end
