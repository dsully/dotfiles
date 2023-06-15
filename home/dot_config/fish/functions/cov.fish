function cov --wraps=pytest
    command pytest -n 0 --cov-report html --cov src $argv
    command open --background htmlcov/index.html
end
