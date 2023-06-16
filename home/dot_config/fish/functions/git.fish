function git --wraps=git

    if test $PWD = $HOME; or string match -q -r $XDG_CONFIG_HOME $PWD
        command chezmoi git -- $argv
    else
        command git $argv
    end
end
