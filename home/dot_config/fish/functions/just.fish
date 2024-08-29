function just --wraps=just --description 'Wrap just / cargo xtask'

    if test -d xtask
        command cargo xtask $argv
    else
        command just $argv
    end
end
