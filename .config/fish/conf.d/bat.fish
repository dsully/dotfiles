# https://github.com/eth-p/bat-extras
if status is-interactive
    if type -q batman
        alias man batman
    end

    if type -q batpipe
        eval (batpipe)
    end
end
