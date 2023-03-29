# Bootstrap
if not set -q $HOSTNAME
    set -Ux HOSTNAME (hostname -f | cut -d . -f 1)
    set -Ux OS (uname -s)
end

set -Ux XDG_CACHE_HOME $HOME/.cache
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux LANG en_US.UTF-8

set fish_greeting ''

fish_add_path --append \
    "$HOME/bin/share" \
    "$HOME/bin/$OS" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin" \
    "$HOME/.local/go/bin" \
    "$HOME/.local/share/nvim/mason/bin" \
    "$HOME/.volta/bin" \
    /Library/Apple/usr/bin

for path in $HOME/bin/Sites/*
    fish_add_path --append $path
end

# Set maxfiles limits higher.
switch $OS
    case Darwin
        ulimit -n 131072
end

if status is-interactive

    # Turn on vi keybindings
    # set -g fish_key_bindings fish_vi_key_bindings
    # set -g fish_key_bindings fish_hybrid_key_bindings
    # bind --all \t accept-autosuggestion
    bind --all \t complete
    # https://github.com/fish-shell/fish-shell/issues/3299

    set -Ux HISTFILE $HOME/.local/share/fish/fish_history

    # Move Golang's path out of $HOME
    set -gx GOPATH $HOME/.local/go
    set -gx GO111MODULE on

    set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config
    set -gx VOLTA_HOME "$HOME/.volta"

    # Silence direnv logging. Hook is invoked via vendor_conf.d/
    set -gx DIRENV_LOG_FORMAT ""

    # Disable EternalTerminal telemetry.
    set -gx ET_NO_TELEMETRY 1

    # Set Nord as the fzf color scheme: https://github.com/junegunn/fzf/blob/master/ADVANCED.md
    set -gx NORD_COLORS "--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88"
    set -gx NORD_COLORS "$NORD_COLORS,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#81A1C1,prompt:#81A1C1,hl+:#81A1C1"

    set -gx FZF_DEFAULT_OPTS --cycle --filepath-word --height=50% --info=hidden --border=sharp $NORD_COLORS

    if test -d $XDG_CONFIG_HOME/repos/private/fish/conf.d
        for file in $XDG_CONFIG_HOME/repos/private/fish/conf.d/*.fish
            source $file
        end
    end
end