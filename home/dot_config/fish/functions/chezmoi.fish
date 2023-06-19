function chezmoi --wraps=chezmoi

    # Don't create a sub-shell for 'cd'
    if test "$argv" = cd
        cd (command chezmoi source-path)

    # Old habits.
    else if set -q argv[1]; and test $argv[1] = "rm"
        command chezmoi remove $argv[2..-1]
    else
        command chezmoi $argv
    end
end
