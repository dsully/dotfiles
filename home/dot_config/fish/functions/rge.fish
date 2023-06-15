function rge -d "Wrapper around ripgrep to open files in $EDITOR"

    set -l matches (command rg -l $argv)

    if test $status -eq 0
        eval $EDITOR $matches
    end
end
