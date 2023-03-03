# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.ftpi5w/fd.fish @ line 2
function et --description 'Wrap et to pass the username, as the SSH config conflicts' --wraps et

    if test (count $argv) -eq 0
        command et
    else
        if string match --entire '@' $argv
            command et $argv

        else
            # --username causes a segfault.
            command et $USER@$argv
        end
    end
end
