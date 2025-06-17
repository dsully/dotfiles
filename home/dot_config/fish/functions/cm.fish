function cm --wraps=chezmoi

    set RPWD (echo $PWD | string replace "$HOME/" "")

    # Don't create a sub-shell for 'cd'
    if test "$argv" = cd
        cd (command chezmoi source-path)

    else if set -q argv[1]; and test $argv[1] = diff
        command chezmoi diff --reverse $argv[2..-1]

    else if set -q argv[1]; and test $argv[1] = rm
        command chezmoi --force destroy $argv[2..-1]

    else if set -q argv[1]; and test $argv[1] = unmanaged
        command chezmoi $argv 2>&1 | string replace -a $RPWD "."
    else
        command chezmoi $argv
    end
end
