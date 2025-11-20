function __python_virtualenv --description "Auto activate/deactivate Python virtualenvs"

    # Check if we are inside a git repository
    if git rev-parse --show-toplevel &>/dev/null
        set root (realpath (git rev-parse --show-toplevel 2>/dev/null))
    else
        set root (pwd -P)
    end

    set -l venv_path ""

    # Case #1: cd'd into a folder which has a .venv in its root.
    #
    # Activate this virtualenv if it's not already activated.
    if test -e "$root/.venv/bin/activate.fish"
        set venv_path "$root/.venv"
    end

    if test -n "$venv_path" -a "$VIRTUAL_ENV" != "$venv_path" -a -e "$venv_path/bin/activate.fish"

        source "$root/.venv/bin/activate.fish" &>/dev/null

        # set -gx VIRTUAL_ENV $venv_path
        # set -gx PATH "$VIRTUAL_ENV/bin" $PATH

    else if test -n "$VIRTUAL_ENV" -a -z "$venv_path"

        if functions -q deactivate
            deactivate
            # else
            #     # Manual cleanup if deactivate isn't available
            #     set -e VIRTUAL_ENV
        end
    end

    # If there's a virtualenv in the root of this repo, we should activate it now.
    # if test -d "$root/.venv"
    #     source "$root/.venv/bin/activate.fish" &>/dev/null
    # end
end
