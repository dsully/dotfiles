function gh --wraps=gh --description 'Wrap gh with 1Password'

    if type -q op
        command op plugin run -- gh $argv
    else
        command gh $argv
    end
end
