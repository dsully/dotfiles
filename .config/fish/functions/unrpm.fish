# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.50tiow/unrpm.fish @ line 1
function unrpm
    command rpm2cpio $argv | cpio -iumdv
end
