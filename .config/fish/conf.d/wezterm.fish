# Wezterm integration.
# https://wezfurlong.org/wezterm/config/lua/config/term.html?h=environment
if status is-interactive

    if test $TERM = wezterm
        set -l TERMINFO_DIR $HOME/.terminfo

        # Different OSes, different paths.
        set -l WEZ_TERMINFO1 $TERMINFO_DIR/77/wezterm
        set -l WEZ_TERMINFO2 $TERMINFO_DIR/w/wezterm

        if not test -f $WEZ_TERMINFO1; or not test -f $WEZ_TERMINFO2
            /usr/bin/tic -x -o $TERMINFO_DIR $XDG_CONFIG_HOME/wezterm/wezterm.terminfo
        end
    end
end
