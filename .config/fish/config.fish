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
set -Ux HOMEBREW_CASK_OPTS "--no-quarantine"
set -Ux VOLTA_HOME "$HOME/.volta"

# Turn on vi keybindings
# set -g fish_key_bindings fish_vi_key_bindings
# set -g fish_key_bindings fish_hybrid_key_bindings
# bind --all \t accept-autosuggestion
bind --all \t complete
# https://github.com/fish-shell/fish-shell/issues/3299

addpath \
    "$HOME/bin/share" \
    "$HOME/bin/$OS" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin" \
    "$HOME/.poetry/bin" \
    "$HOME/.volta/bin" \
    /Users/dsully/Library/Python/3.8/bin \
    /Library/Apple/usr/bin \
    /usr/local/bin \
    /usr/local/sbin

if test -e "$HOME/.config/fish/lib/github.fish"
    source "$HOME/.config/fish/lib/github.fish"
end

if test -e "$HOME/.config/fish/lib/linkedin.fish"
    source "$HOME/.config/fish/lib/linkedin.fish"
end

addpath \
    /usr/bin \
    /bin \
    /sbin \
    /usr/sbin

# Clear out entries from /etc/paths.d and add our paths to the actual PATH.
set -e PATH
set -gx PATH $fish_user_paths
set -gx MANPATH /usr/share/man:/usr/local/share/man

# Python
set -gx PYTHONSTARTUP ~/.config/python/startup.py

# https://github.com/Homebrew/homebrew-command-not-found
set HB_CNF_HANDLER /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.fish

if test -f $HB_CNF_HANDLER
   source $HB_CNF_HANDLER
end

# 3rd party.
if status --is-interactive

    # Silence direnv logging and invoke it's hook.
    set -gx DIRENV_LOG_FORMAT ""
    eval (direnv hook fish)
end
