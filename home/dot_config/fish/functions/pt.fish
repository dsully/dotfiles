## App shortcuts with completion for filetype
function pt --wraps=pytest

    if type -q pytest
        command pytest -n 0 $argv
    else
        echo "pytest not found"
        return 1
    end
end
