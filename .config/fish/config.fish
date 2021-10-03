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

set -Ux GOPATH $HOME/.local/go
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
    "$HOME/.local/go/bin" \
    "$HOME/.poetry/bin" \
    "$HOME/.volta/bin" \
    "$HOME/.volta/bin" \
    /home/linuxbrew/.linuxbrew/bin \
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

# https://github.com/PatrickF1/fzf.fish
if type -q fzf_configure_bindings
    set fzf_preview_file_cmd bat --line-range :100 --color=always --plain
    set fzf_preview_dir_cmd lsd --tree --depth=1

    set fzf_fd_opts --hidden --exclude ".git" --exclude ".direnv" --exclude ".pytest_cache"
    set fzf_dir_opts --bind 'ctrl-e:execute(command nvim {} >/dev/tty)'

    # Bind Ctrl-t to use fzf for the current directory.
    fzf_configure_bindings --directory=\ct
end
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
    # https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
    set -gx HOMEBREW_CASK_OPTS --no-quarantine

    # https://github.com/Homebrew/homebrew-command-not-found
    switch $OS
        case Darwin
            source /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.fish
        case Linux
            source /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.fish
    end
end
