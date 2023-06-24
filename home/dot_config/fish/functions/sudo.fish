function sudo --wraps=sudo -d "sudo or doas wrapper."

    if type -q doas
        command doas $argv
    else
        command sudo $argv
    end
end
