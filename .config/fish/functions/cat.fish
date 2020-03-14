# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.DnKdnn/cat.fish @ line 2
function cat --wraps=bat --description 'Use bat instead of cat'
    command bat --style plain --theme base16 $argv
end
