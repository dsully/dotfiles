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
set -Ux HISTFILE $HOME/.local/share/fish/fish_history

# Vim & Pager
set -gx EDITOR vi
set -gx VISUAL vi
set -gx PAGER "less -FiRSwX"
set -gx MANPAGER "less -FiRSwX"

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

    if type -q go
        # Move Golang's path out of $HOME
        set -gx GOPATH $HOME/.local/go
        set -gx GO111MODULE on
    end

    if type -q rg
        set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
    end

    if type -q volta
        set -gx VOLTA_HOME "$HOME/.volta"
    end

    # Set Nord as the fzf color scheme: https://github.com/junegunn/fzf/blob/master/ADVANCED.md
    set -l NORD_COLORS "--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88"
    set -l NORD_COLORS "$NORD_COLORS,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#81A1C1,prompt:#81A1C1,hl+:#81A1C1"

    set -gx FZF_DEFAULT_OPTS --cycle --filepath-word --height=50% --info=hidden --border=sharp $NORD_COLORS

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
    if type -q direnv
        set -gx DIRENV_LOG_FORMAT ""
    end

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
    # if not functions -q fisher
    #     curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    #     fish -c fisher
    # end

    # Kitty terminal emulator integration.
    set -g KITTY_SHELL_INTEGRATION no-cursor

    # Start SSH agent and set environment.
    if test -z (pgrep ssh-agent | string collect)
        eval (ssh-agent -c) >/dev/null
        set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
        set -Ux SSH_AGENT_PID $SSH_AGENT_PID

        switch $OS
            case Darwin
                command ssh-add --apple-use-keychain -q
        end
    end

    # https://github.com/Peltoche/lsd
    if type -q lsd
        alias ls lsd
    end

    # http://github.com/neovim/neovim
    if type -q nvim
        alias vi nvim
        alias vim nvim
        alias view "nvim -R"

        set -gx EDITOR nvim
        set -gx VISUAL nvim
    end

    # chdir to the root of a git repo.
    alias cdr 'cd (git rev-parse --show-toplevel 2> /dev/null)'

    # These aren't currently installed, but keep the config around.
    # if type -q atuin
    #     set -gx ATUIN_SUPPRESS_TUI true
    #
    #     atuin init fish | source
    # end
    #
    # if type -q sk
    #     set -gx SKIM_DEFAULT_OPTIONS --height=30% $NORD_COLORS
    #     status --is-interactive; and skim_key_bindings
    # end
end
