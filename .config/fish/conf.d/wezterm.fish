# Wezterm integration.
# https://wezfurlong.org/wezterm/config/lua/config/term.html?h=environment
if status is-interactive

    if test $TERM = wezterm
        set -l TERMINFO_DIR $HOME/.terminfo
        set -l WEZ_TERMINFO $TERMINFO_DIR/77/wezterm

        if not test -f $WEZ_TERMINFO
            /usr/bin/tic -x -o $TERMINFO_DIR $XDG_CONFIG_HOME/wezterm/wezterm.terminfo
        end
    end
end
