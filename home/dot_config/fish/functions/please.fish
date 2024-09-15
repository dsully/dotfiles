function please --description 'Run the last command with sudo'
    if command -q doas
        set sudo doas
    else
        set sudo sudo
    end

    if count $argv >/dev/null
        if [ $history[$argv[1]] = please ]
            please (math $argv[1] + 1)
        else
            eval command $sudo $history[$argv[1]]
        end
    else
        please 1
    end
end
