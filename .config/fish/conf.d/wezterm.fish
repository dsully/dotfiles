# Wezterm integration.
# https://wezfurlong.org/wezterm/config/lua/config/term.html?h=environment
if status is-interactive

    if test $TERM = wezterm
        set -l TERMINFO_DIR $HOME/.terminfo

        # Different OSes, different paths.
        switch $OS
            case Darwin
                set -f WEZ_TERMINFO $TERMINFO_DIR/77/wezterm
            case Linux
                set -f WEZ_TERMINFO $TERMINFO_DIR/w/wezterm
        end

        if not test -f $WEZ_TERMINFO
            /usr/bin/tic -x -o $TERMINFO_DIR $XDG_CONFIG_HOME/wezterm/terminfo
        end
    end
end
