# Bootstrap
if not set -q HOSTNAME
    set -Ux HOSTNAME (hostname -f | cut -d . -f 1)
    set -Ux OS (uname -s)
end

set -gx XDG_BIN_HOME $HOME/.local/bin
set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_PICTURES_DIR $HOME/iCloud/Screenshots
set -gx XDG_STATE_HOME $HOME/.local/state

set -gx LANG en_US.UTF-8

set -g fish_greeting ""

fish_add_path -g $XDG_BIN_HOME

# $XDG_CONFIG_HOME/fish/themes/nordish.fish
fish_config theme choose Nordish

# Set fisher and auto-generated .fish files to be outside of ~/.config/fish
# This will get picked up by $__fish_vendor_*
set -gx fish_cache $XDG_CACHE_HOME/fish
set -gx fisher_path $fish_cache

# Turn on vi keybindings
# This doesn't work with "magic enter"
# set -g fish_key_bindings fish_hybrid_key_bindings

set -gx HISTFILE $XDG_DATA_HOME/fish/fish_history

set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config
set -gx TREE_SITTER_DIR $XDG_CONFIG_HOME/tree-sitter

# Silence direnv logging. Hook is invoked via vendor_conf.d/
set -gx DIRENV_LOG_FORMAT ""

abbr --add dc cd

# Set `LS_COLORS` via https://github.com/sharkdp/vivid
if status is-interactive

    if not string length --quiet $LS_COLORS; and command -q vivid
        set -Ux LS_COLORS (vivid generate nord)
    end
end

# Delete git remote branch tab completion.
complete -f -c git -n '__fish_git_using_command checkout' \
    -n 'not contains -- -- (commandline -opc)' \
    -ka '(__fish_git_unique_remote_branches)' \
    -d 'Unique Remote Branch'

# Up the open file limit.
ulimit -n 8192
