# This is here instead of in the functions directory because they utilize event handlers which autoloading does not support.

# --on-variable is a fish builtin that changes whenever the directory changes
# so this function will run whenever the directory changes
function auto_pwd --on-variable PWD

    if test -d "$PWD/.git" && type -q devmoji-log
        devmoji-log
    end

    __python_virtualenv
end
