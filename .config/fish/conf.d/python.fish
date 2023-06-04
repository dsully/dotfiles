if status is-interactive

    set -gx PIP_DISABLE_PIP_VERSION_CHECK 1
    set -gx PIP_REQUIRE_VIRTUALENV 1
    set -gx PIPX_DEFAULT_PYTHON $HOMEBREW_PREFIX/bin/python3 # don't break venv's on brew upgrade
    set -gx PYTHONDONTWRITEBYTECODE 1

    set -l startup $XDG_CONFIG_HOME/python/startup.py

    if test -f $startup
        set -gx PYTHONSTARTUP $startup
    end
end
