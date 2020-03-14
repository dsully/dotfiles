# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.UmZqe5/ldd.fish @ line 1
function ldd --wraps='otool -L'
    switch $OS
        case Darwin
          command otool -L $argv;
        case Linux
          command ldd $argv
        end
end
