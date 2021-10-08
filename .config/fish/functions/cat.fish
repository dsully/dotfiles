# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.DnKdnn/cat.fish @ line 2
function cat --wraps=bat --description 'Use bat instead of cat'

    if string match --quiet --regex ".*\.md\$" $argv[1]
        mdcat $argv[1]
    else
        command bat --style plain --theme Nord $argv
    end
end
