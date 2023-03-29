function croc --description 'Run croc with --local --yes' --wraps croc
    command croc --yes --local $argv
end
