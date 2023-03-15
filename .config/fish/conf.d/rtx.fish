# https://github.com/jdxcode/rtx
if status is-interactive; and type -q rtx
    set -gx RTX_EXPERIMENTAL 1
    set -gx RTX_USE_TOML 1
    set -gx RTX_PYTHON_DEFAULT_PACKAGES_FILE $XDG_CONFIG_HOME/rtx/default-python-packages.txt

    rtx activate fish | source
end
