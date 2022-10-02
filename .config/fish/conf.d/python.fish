if status is-interactive

    set -gx PYTHONSTARTUP $HOME/.config/python/startup.py
    set -gx PYTHON_VERSION 3.10

    fish_add_path --append "/export/apps/python/$PYTHON_VERSION/bin" "$HOME/Library/Python/$PYTHON_VERSION/bin"

    # Python PEP-582 PDM integration: https://pdm.fming.dev
    set -gx PYTHONPATH "$HOME/.local/pipx/venvs/pdm/lib/python$PYTHON_VERSION/site-packages/pdm/pep582"
end
