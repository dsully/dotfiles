function rm --wraps=rip --description 'Safe remove'

    if type -q rip
        command rip $argv
    else
        command rm $argv
    end
end
