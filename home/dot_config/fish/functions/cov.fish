function cov --wraps=pytest
    pt --cov-report html --cov src $argv

    if test -f htmlcov/index.html
        command /usr/bin/open --background htmlcov/index.html
    end
end
