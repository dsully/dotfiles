function rm --wraps rm

    if type -q gomi
        command gomi $argv
    else
        /bin/rm $argv
    end
end
