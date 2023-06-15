# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.y5SBcJ/unzip.fish @ line 2
function unzip
    if test -d $HOMEBREW_PREFIX/opt/unzip/bin
        command $HOMEBREW_PREFIX/opt/unzip/bin/unzip $argv
    else
        command unzip $argv
    end
end
