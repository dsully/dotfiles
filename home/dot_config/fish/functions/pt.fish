## App shortcuts with completion for filetype
function pt --wraps=pytest

    if type -q pytest
        command pytest $argv
    else
        echo "pytest not found"
        return 1
    end
end
