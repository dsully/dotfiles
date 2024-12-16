if status is-interactive

    set -gx PIP_CACHE_DIR $XDG_CACHE_HOME/pip
    set -gx PIP_CONFIG_FILE $XDG_CONFIG_HOME/pip/pip.conf
    set -gx PIP_DISABLE_PIP_VERSION_CHECK 1
    set -gx PIP_REQUIRE_VIRTUALENV 1

    set -gx POETRY_CACHE_DIR $XDG_CACHE_HOME/poetry
    set -gx POETRY_CONFIG_DIR $XDG_CONFIG_HOME/poetry
    set -gx POETRY_DATA_DIR $XDG_DATA_HOME/poetry

    set -gx PYTHONDONTWRITEBYTECODE 1

    set -l startup $XDG_CONFIG_HOME/python/startup.py

    if test -f $startup
        set -gx PYTHONSTARTUP $startup
    end

    # https://rye-up.com
    if test -d $HOME/.rye
        set -gx RYE_HOME $HOME/.rye
        fish_add_path -g $RYE_HOME/shims
    end

    if command -q ruff
        function f8 --wraps ruff
            command ruff check $argv
        end
    else
        function f8 --wraps flake8
            command flake8 --config $XDG_CONFIG_HOME/flake8/config $argv
        end
    end

    function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
        status --is-command-substitution; and return

        # Check if we are inside a git directory
        if git rev-parse --show-toplevel &>/dev/null
            set gitdir (builtin realpath (git rev-parse --show-toplevel))
            set repo (basename $gitdir)
            set cwd (pwd -P)

            # Most common right now, so check for it first.
            set venv "$gitdir/build/$repo/environments/development-venv"

            if test -x "$venv/bin/python3"
                set -gx VIRTUAL_ENV $venv
                fish_add_path "$venv/bin"
                return
            end

            # While we are still inside the git directory, find the closest
            # virtualenv starting from the current directory.
            while string match "$gitdir*" "$cwd" &>/dev/null

                for venv in .venv venv
                    if test -x "$venv/bin/python3"
                        set -gx VIRTUAL_ENV $venv
                        fish_add_path "$venv/bin"
                        return
                    end
                end

                set cwd (path dirname "$cwd")
            end
        else
            # If virtualenv activated but we are not in a git directory, deactivate.
            if test -n "$VIRTUAL_ENV"
                fish_remove_path "$VIRTUAL_ENV/bin"
                set -e VIRTUAL_ENV
            end
        end
    end
end
