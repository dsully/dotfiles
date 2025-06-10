if status is-interactive

    set -gx PIP_CACHE_DIR $XDG_CACHE_HOME/pip
    set -gx PIP_CONFIG_FILE $XDG_CONFIG_HOME/pip/pip.conf
    set -gx PIP_DISABLE_PIP_VERSION_CHECK 1
    set -gx PIP_REQUIRE_VIRTUALENV 1

    set -gx POETRY_CACHE_DIR $XDG_CACHE_HOME/poetry
    set -gx POETRY_CONFIG_DIR $XDG_CONFIG_HOME/poetry
    set -gx POETRY_DATA_DIR $XDG_DATA_HOME/poetry

    set -gx PYTHONDONTWRITEBYTECODE 1
end
