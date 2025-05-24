function rge -d "Wrapper around ripgrep to open files in $EDITOR"

    set -l matches (command rg --color=never -l $argv)

    if test $status -eq 0
        $EDITOR $matches
    end
end
