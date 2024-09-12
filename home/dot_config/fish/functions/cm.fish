function cm --wraps=chezmoi

    # Don't create a sub-shell for 'cd'
    if test "$argv" = cd
        cd (command chezmoi source-path)

    else if set -q argv[1]; and test $argv[1] = diff
        command chezmoi diff --reverse $argv[2..-1]

    else if set -q argv[1]; and test $argv[1] = rm
        # Old habits.
        command chezmoi --force forget $argv[2..-1]
    else
        command chezmoi $argv
    end
end
