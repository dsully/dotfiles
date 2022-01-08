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

# Python
set -gx PYTHONSTARTUP ~/.config/python/startup.py
set -gx PYTHON_VERSION 3.10

# Move Golang's path out of $HOME
set -gx GOPATH $HOME/.local/go
set -gx GO111MODULE on

alias ls lsd
alias vi nvim
alias vim nvim
alias view "nvim -R"

# Turn on vi keybindings
# set -g fish_key_bindings fish_vi_key_bindings
# set -g fish_key_bindings fish_hybrid_key_bindings
# bind --all \t accept-autosuggestion
bind --all \t complete
# https://github.com/fish-shell/fish-shell/issues/3299

# Brew is installed in different places depending on OS and architecture.
if test -d /opt/homebrew
    set -Ux HOMEBREW_PREFIX /opt/homebrew
else if test -d /usr/local/Homebrew
    set -Ux HOMEBREW_PREFIX /usr/local
else if test -d /home/linuxbrew/.linuxbrew
    set -Ux HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
end

fish_add_path --append \
    "$HOME/bin/share" \
    "$HOME/bin/$OS" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin" \
    "$HOME/.local/go/bin" \
    "$HOME/.poetry/bin" \
    "$HOME/.volta/bin" \
    "$HOMEBREW_PREFIX/bin" \
    "$HOMEBREW_PREFIX/sbin" \
    "$HOMEBREW_PREFIX/opt/python@$PYTHON_VERSION/bin" \
    "$HOMEBREW_PREFIX/opt/python@$PYTHON_VERSION/libexec/bin" \
    "$HOME/Library/Python/$PYTHON_VERSION/bin" \
    /Library/Apple/usr/bin \
    /usr/local/bin \
    /usr/local/sbin

if test -f "$HOME/.config/fish/lib/github.fish"
    source "$HOME/.config/fish/lib/github.fish"
end

if test -f "$HOME/.config/fish/lib/work.fish"
    source "$HOME/.config/fish/lib/work.fish"
end

fish_add_path --append \
    /usr/bin \
    /bin \
    /sbin \
    /usr/sbin

set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
set -gx VOLTA_HOME "$HOME/.volta"

if test -f "/Applications/kitty.app/Contents/Resources/kitty/terminfo"
    set -gx TERMINFO "/Applications/kitty.app/Contents/Resources/kitty/terminfo"
end

if status is-interactive

    # Set Nord as the fzf color scheme: https://github.com/junegunn/fzf/blob/master/ADVANCED.md
    set -x FZF_DEFAULT_OPTS --cycle \
        --filepath-word \
        --height=50% \
        --info=hidden \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --color='bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'

    # https://github.com/PatrickF1/fzf.fish
    if type -q fzf_configure_bindings
        set fzf_preview_file_cmd bat --line-range :100 --color=always --plain
        set fzf_preview_dir_cmd lsd --tree --depth=1

        set fzf_fd_opts --hidden --exclude ".git" --exclude ".direnv" --exclude ".pytest_cache"
        set fzf_dir_opts --bind 'ctrl-e:execute(command nvim {} >/dev/tty)'

        # Bind Ctrl-t to use fzf for the current directory.
        fzf_configure_bindings --directory=\ct
    end

    # Silence direnv logging. Hook is invoked via vendor_conf.d/
    set -gx DIRENV_LOG_FORMAT ""

    if type -q zoxide
        zoxide init fish --cmd j | source

        set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS '--preview "_fzf_preview_file {}"'

        alias za "zoxide add"
        alias zq "zoxide query"
        alias zr "zoxide remove"
    end

    # Set `LS_COLORS` via https://github.com/sharkdp/vivid
    if type -q vivid
        set -gx LS_COLORS (vivid generate nord)
    end

    # https://github.com/eth-p/bat-extras
    if type -q batman
        alias man batman
    end

    if type -q batpipe
        eval (batpipe)
    end

    # make less behave with XDG
    if [ ! -d "$XDG_CACHE_HOME/less" ]
        mkdir -p "$XDG_CACHE_HOME/less"
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
    set -gx HOMEBREW_BAT 1
    set -gx HOMEBREW_FORCE_BREWED_GIT 1
    set -gx HOMEBREW_INSTALL_FROM_API 1
    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_NO_COMPAT 1
    set -gx HOMEBREW_NO_ENV_HINTS 1

    # https://github.com/Homebrew/homebrew-command-not-found
    set HANDLER Library/Taps/homebrew/homebrew-command-not-found/handler.fish

    if test -f "$HOMEBREW_PREFIX/$TAPS"
        source "$HOMEBREW_PREFIX/$TAPS"
    else if test -f "$HOMEBREW_PREFIX/Homebrew/$TAPS"
        source "$HOMEBREW_PREFIX/Homebrew/$TAPS"
    end

    # Kitty terminal emulator integration.
    set -g KITTY_SHELL_INTEGRATION no-cursor

    if set -q KITTY_INSTALLATION_DIR
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
end
