function pip --wraps=pip3
    command pip3 --disable-pip-version-check $argv
end
