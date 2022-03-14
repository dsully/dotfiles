# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.CPuVJ8/top.fish @ line 2
function top --wraps='top -s 2 -ocpu -Otime'
    switch $OS
        case Darwin
            command top -s 2 -ocpu -Otime $argv
        case Linux
            command htop
    end
end
