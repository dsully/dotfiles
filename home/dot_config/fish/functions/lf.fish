function lf --wraps=pytest

    if type -q pytest
        command pytest -n 0 --lf $argv
    else
        echo "pytest not found"
    end
end
