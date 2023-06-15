# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.ftpi5w/fd.fish @ line 2
function fd --description 'Run fd with --full-path always' --wraps fd
    command fd --full-path $argv
end
