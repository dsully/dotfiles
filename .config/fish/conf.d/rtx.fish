# https://github.com/jdxcode/rtx
if status is-interactive; and test -f $HOMEBREW_PREFIX/bin/rtx
    set -gx RTX_USE_TOML 1

    $HOMEBREW_PREFIX/bin/rtx activate fish | source
end
