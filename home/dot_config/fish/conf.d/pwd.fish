# This is here instead of in the functions directory because they utilize event handlers which autoloading does not support.

# --on-variable is a fish builtin that changes whenever the directory changes
# so this function will run whenever the directory changes
function auto_pwd --on-variable PWD
    if test -d .git && git rev-parse --git-dir >/dev/null 2>&1

        echo "## Recent Activity" | glow -s dark -w 120 | string trim

        # brew install hub
        # volta install devmoji
        hub l -5 --since='1 week ago' | devmoji --log --color | sed 's/^/  /'

        echo
    end
end
