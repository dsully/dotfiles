# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.AxiNgQ/diffr.fish @ line 1
function diffr --wraps=diffr
    command diffr \
        --colors added:none:background:none \
        --colors removed:none:background:none \
        --colors refine-added:none:foreground:green:bold \
        --colors refine-removed:none:foreground:red:bold \
        $argv
end
