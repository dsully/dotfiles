# Wezterm integration.
# https://wezfurlong.org/wezterm/config/lua/config/term.html?h=environment
if status is-interactive

    if test $TERM = wezterm; and not infocmp wezterm &>/dev/null
        set -l TERMINFO_DIR $HOME/.terminfo

        if fish_is_root_user
            set TERMINFO_DIR /usr/share/terminfo
        end

        /usr/bin/tic -x -o $TERMINFO_DIR $XDG_CONFIG_HOME/wezterm/terminfo
    end
end
