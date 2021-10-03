set fish_greeting ''

# Bootstrap
if test -z "$HOSTNAME"
    set -Ux HOSTNAME (hostname -f | cut -d . -f 1)
    set -Ux OS (uname -s)
end

set -Ux fish_term24bit 1
set -Ux XDG_CACHE_HOME $HOME/.cache
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux LANG en_US.UTF-8

# Vim & Pager
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER "less -FiRSwX"
set -gx MANPAGER "less -FiRSwX"

alias ls lsd
alias python python3
alias vi nvim
alias vim nvim
alias view "nvim -R"

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
    "$HOME/.local/volta/bin" \
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

# Set `LS_COLORS` via https://github.com/sharkdp/vivid
if type -q vivid
    set -gx LS_COLORS (vivid generate nord)
end
# https://github.com/PatrickF1/fzf.fish
if type -q fzf_configure_bindings
    set fzf_preview_file_cmd bat --line-range :100 --color=always --plain
    set fzf_preview_dir_cmd lsd --tree --depth=1

    set fzf_fd_opts --hidden --exclude ".git" --exclude ".direnv" --exclude ".pytest_cache"
    set fzf_dir_opts --bind 'ctrl-e:execute(command nvim {} >/dev/tty)'

    # Bind Ctrl-t to use fzf for the current directory.
    fzf_configure_bindings --directory=\ct
end

# Move Golang's path out of $HOME
set -gx GOPATH $HOME/.local/go
set -gx GO111MODULE on

set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
set -gx VOLTA_HOME "$HOME/.local/volta"

# Python
set -gx PYTHONSTARTUP ~/.config/python/startup.py

# Silence direnv logging and invoke it's hook.
if type -q direnv
    set -gx DIRENV_LOG_FORMAT ""
    direnv hook fish | source
end

if type -q zoxide
    zoxide init fish --cmd j | source

    set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS '--preview "_fzf_preview_file {}"'

    alias za "zoxide add"
    alias zq "zoxide query"
    alias zr "zoxide remove"
end

# https://github.com/eth-p/bat-extras
if type -q batman
    alias man batman
end

if type -q batpipe
    eval (batpipe)
end

# Forward term info in kitty when connection via ssh
if string match -q xterm-kitty -- $TERM
    alias ssh "kitty +kitten ssh"
end

if test -f "/Applications/kitty.app/Contents/Resources/kitty/terminfo"
    set -gx TERMINFO "/Applications/kitty.app/Contents/Resources/kitty/terminfo"
end

if status is-interactive

    # make less behave with XDG
    if [ ! -d "$XDG_CACHE_HOME"/less ]
        mkdir -p "$XDG_CACHE_HOME"/less
    end

    set -gx LESSKEY "$XDG_CACHE_HOME"/less/lesskey
    set -gx LESSHISTFILE "$XDG_CACHE_HOME"/less/history

    # Install fisher if it isn't already.
    if not functions -q fisher
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
        fish -c fisher
    end

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
