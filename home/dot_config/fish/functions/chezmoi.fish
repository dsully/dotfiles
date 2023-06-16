function chezmoi --wraps=chezmoi
    if test "$argv" = cd
        cd (command chezmoi source-path)
    else
        command chezmoi $argv
    end
end
