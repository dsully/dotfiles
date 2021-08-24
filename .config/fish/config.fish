set fish_greeting ''

# Bootstrap
if test -z "$HOSTNAME"
    set -Ux HOSTNAME (hostname -f | cut -d . -f 1)
    set -Ux OS (uname -s)
end

set -Ux fish_term24bit 1
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux LANG en_US.UTF-8

# Vim & Pager
set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux PAGER "less -FiRSwX"
set -Ux MANPAGER "less -FiRSwX"

abbr -a vi nvim
abbr -a vim nvim
abbr -a view nvim -R

set -Ux RIPGREP_CONFIG_PATH $HOME/.ripgreprc
set -Ux HOMEBREW_CASK_OPTS "--no-quarantine"
set -Ux VOLTA_HOME "$HOME/.volta"

# Turn on vi keybindings
# set -g fish_key_bindings fish_vi_key_bindings
# set -g fish_key_bindings fish_hybrid_key_bindings
# bind --all \t accept-autosuggestion
bind --all \t complete
# https://github.com/fish-shell/fish-shell/issues/3299

fish_add_path --append \
    "$HOME/bin/share" \
    "$HOME/bin/$OS" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin" \
    "$HOME/.poetry/bin" \
    "$HOME/.volta/bin" \
    /Users/dsully/Library/Python/3.8/bin \
    /Users/dsully/Library/Python/3.9/bin \
    /Users/dsully/Library/Python/3.10/bin \
    /Library/Apple/usr/bin \
    /usr/local/bin \
    /usr/local/sbin

if test -f "$HOME/.config/fish/lib/github.fish"
    source "$HOME/.config/fish/lib/github.fish"
end

if test -f "$HOME/.config/fish/lib/linkedin.fish"
    source "$HOME/.config/fish/lib/linkedin.fish"
end

fish_add_path --append \
    /usr/bin \
    /bin \
    /sbin \
    /usr/sbin

# Python
set -gx PYTHONSTARTUP ~/.config/python/startup.py

# https://github.com/Homebrew/homebrew-command-not-found
set HB_CNF_HANDLER /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.fish

if test -f $HB_CNF_HANDLER
   source $HB_CNF_HANDLER
end

# 3rd party.
if status --is-interactive

    if test -f "/Applications/kitty.app/Contents/Resources/kitty/terminfo"
        set -gx TERMINFO "/Applications/kitty.app/Contents/Resources/kitty/terminfo"
    end

    # Silence direnv logging and invoke it's hook.
    if type -q direnv
        set -gx DIRENV_LOG_FORMAT ""
        direnv hook fish | source
    end

    if type -q zoxide
        zoxide init fish --cmd j | source
    end
end
