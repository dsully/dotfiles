if status is-interactive
    fish_add_path -g $HOME/.cargo/bin

    if command -q bacon
        set -gx BACON_PREFS $XDG_CONFIG_HOME/bacon/prefs.toml
    end
end
