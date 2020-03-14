# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.93rjdK/fix-dir-permissions.fish @ line 2
function fix-dir-permissions --description 'Set directory positions to 755'
    command fd --full-path --type d --exec "chmod 755" $argv
end
