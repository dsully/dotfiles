#!/bin/bash

# Adapted from: https://github.com/branchvincent/dotfiles

[ "${DIRENV_DEBUG-}" = "" ] || set -x

# Copy of stdlib's `__dump_at_exit`, but logs on failure
# https://github.com/direnv/direnv/issues/893
__my_dump_at_exit() {
    local ret=$?
    [[ $ret == 0 ]] || echo -e "\033[31mDIRENV FAILED! To debug: export DIRENV_DEBUG=1\033[0m" >&2
    # shellcheck disable=SC2154
    "$direnv" dump json "" >&3
    trap - EXIT
    exit "$ret"
}
trap __my_dump_at_exit EXIT

# Usage: layout auto
#
# Detects and loads project based on file structure
layout_auto() {
    log_status "detecting layout"
    if [[ -f go.mod ]]; then
        log_status "detected go project"
        layout go
    elif [[ -f package.json ]]; then
        log_status "detected node project"
        layout nodejs
    elif [[ -f poetry.lock ]]; then
        log_status "detected poetry project"
        layout poetry
    elif [[ -f build.gradle && -f setup.py ]]; then
        log_status "detected pygradle project"
        layout pygradle
    elif [[ -f pdm.lock ]]; then
        log_status "detected pdm project"
        layout pdm
    elif [[ -f pyproject.toml ]]; then
        log_status "detected python project"
        layout python
    fi
    dotenv_if_exists
}

### Go ###
layout_go() {
    export GOBIN="$PWD/bin"
    PATH_add bin
}

### Node ###
layout_nodejs() {
    PATH_add node_modules/.bin
    watch_file package-lock.json yarn.lock
}

### Python ###

layout_python() {
    if [[ -d "$PWD/venv" ]]; then
        export VIRTUAL_ENV="$PWD/venv"
    elif [[ -d "$PWD/.venv" ]]; then
        export VIRTUAL_ENV="$PWD/.venv"
    fi

    PATH_add "$VIRTUAL_ENV/bin"
}

layout_poetry() {
    watch_file poetry.lock

    layout_python

    export PIP_PYTHON="$VIRTUAL_ENV/bin/python"
    export POETRY_ACTIVE=1
}

layout_pdm() {
    watch_file pdm.lock

    if [[ ! -e .venv || ! -e venv || ! -e .pep582 ]]; then

        if [[ $(pdm config python.use_venv | grep -c "False") == 1 ]]; then

            # Create a stub file if it doesn't exist the first time.
            if [[ ! -f .pep582 ]]; then
                pdm --pep582 >.pep582
            fi
        fi
    fi

    if [[ -f .pep582 ]]; then

        # Activate PEP 582 (faster equivalent to `pdm --pep582`)
        # shellcheck disable=SC1091
        source .pep582
        PATH_add "$PWD"/__pypackages__/*/bin

    else
        layout_python
    fi
}

layout_pygradle() {
    PATH_add "$VIRTUAL_ENV/bin"

    REPO="$(basename "$PWD")"
    VIRTUAL_ENV="$(expand_path "../build/$REPO/environments/development-venv")"

    if [ -x "$VIRTUAL_ENV/bin/python" ]; then
        PATH_add "$VIRTUAL_ENV/bin"

        export VIRTUAL_ENV
    fi
}

if [[ ! -s .envrc ]]; then
    layout auto
fi
