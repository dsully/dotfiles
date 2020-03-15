set fish_greeting ''

# Bootstrap
if test -z "$HOSTNAME"
    set -Ux HOSTNAME (hostname -f | cut -d . -f 1)
    set -Ux OS (uname -s)
end

set -Ux TERM xterm-color
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux LANG en_US.UTF-8

# Vim & Pager
set -Ux EDITOR vim
set -Ux VISUAL vim
set -Ux PAGER "less -FirSwX"
set -Ux MANPAGER "less -FirSwX"

set -Ux RIPGREP_CONFIG_PATH $HOME/.ripgreprc

# Turn on vi keybindings
# set -g fish_key_bindings fish_vi_key_bindings
# set -g fish_key_bindings fish_hybrid_key_bindings
# bind --all \t accept-autosuggestion
bind --all \t complete
# https://github.com/fish-shell/fish-shell/issues/3299

if test -e "$HOME/.config/fish/lib/github.fish"
    source "$HOME/.config/fish/lib/github.fish"
end

if test -e "$HOME/.config/fish/lib/linkedin.fish"
    source "$HOME/.config/fish/lib/linkedin.fish"
end

if test -z "$fish_user_paths"
    addpath \
        "$HOME/bin/share" \
        "$HOME/bin/$OS" \
        "$HOME/.cargo/bin" \
        "$HOME/.poetry/bin" \
        "$HOME/bin/Sites/LinkedIn" \
        "$HOME/.local/bin" \
        /usr/local/bin \
        /usr/local/sbin \
        /usr/local/linkedin/bin \
        /export/apps/python/3.7/bin \
        /export/apps/xtools/bin \
        /export/apps/mysql/5.7/bin \
        /usr/bin \
        /bin \
        /sbin \
        /usr/sbin
end

# Clear out entries from /etc/paths.d and add our paths to the actual PATH.
set -e PATH
set -gx PATH $fish_user_paths
set -gx MANPATH /usr/share/man:/usr/local/share/man

# https://github.com/ajeetdsouza/zoxide
set -gx _ZO_DATA $HOME/.local/zoxide

# 3rd party.
if status --is-interactive

    # Silence direnv logging and invoke it's hook.
    set -gx DIRENV_LOG_FORMAT ""
    eval (direnv hook fish)
end
