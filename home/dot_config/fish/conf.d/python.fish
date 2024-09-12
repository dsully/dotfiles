if status is-interactive

    # Don't break virtualenv's on brew upgrade
    set -gx PIPX_DEFAULT_PYTHON $HOMEBREW_PREFIX/bin/python3
    set -gx PIPX_HOME $XDG_DATA_HOME/pipx

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

    if command -q ruff
        set -f linter ruff
        set -f args "check $argv"
    else
        set -f linter flake8
        set -f args "--config $XDG_CONFIG_HOME/flake8/config $args"
    end

    function f8 --wraps $linter
        $linter $args
    end

    function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
        status --is-command-substitution; and return

        # Check if we are inside a git directory
        if git rev-parse --show-toplevel &>/dev/null
            set gitdir (builtin realpath (git rev-parse --show-toplevel))
            set repo (basename $gitdir)
            set cwd (pwd -P)

            # Most common right now, so check for it first.
            set pygradle "$gitdir/build/$repo/environments/development-venv/bin/activate.fish"

            if test -e $pygradle
                source $pygradle &>/dev/null
                return
            end

            # While we are still inside the git directory, find the closest
            # virtualenv starting from the current directory.
            while string match "$gitdir*" "$cwd" &>/dev/null

                for venv in .venv venv
                    if test -e "$cwd/$venv/bin/activate.fish"
                        source "$cwd/$venv/bin/activate.fish" &>/dev/null
                        return
                    end
                end

                set cwd (path dirname "$cwd")
            end
        else

            # If virtualenv activated but we are not in a git directory, deactivate.
            if functions --query deactivate
                if test -n "$VIRTUAL_ENV"
                    deactivate
                end
            end
        end
    end
end
