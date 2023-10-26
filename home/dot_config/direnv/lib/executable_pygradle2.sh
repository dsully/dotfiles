#!/usr/bin/env bash

layout_pygradle2() {
    REPO="$(basename "$PWD")"
    VIRTUAL_ENV="$(expand_path "../build/$REPO/environments/development-venv")"

    if [ -x "$VIRTUAL_ENV/bin/python" ]; then
        PATH_add "$VIRTUAL_ENV/bin"

        export VIRTUAL_ENV
    fi
}
