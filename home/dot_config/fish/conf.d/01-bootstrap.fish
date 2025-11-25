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

# Pull in files from the cache directory.
# set -a fish_complete_path $XDG_CACHE_HOME/fish/completions $XDG_CACHE_HOME/fish/generated_completions
# set -a fish_function_path $XDG_CACHE_HOME/fish/functions

# if test -d $XDG_CACHE_HOME/fish/conf.d
#
#     for file in $XDG_CACHE_HOME/fish/conf.d/*.fish
#         if test -f $file
#             source $file
#         end
#     end
# end

# $XDG_CONFIG_HOME/fish/themes/nordish.fish
fish_config theme choose Nordish

# Turn on vi keybindings
# This doesn't work with "magic enter"
# set -g fish_key_bindings fish_hybrid_key_bindings

set -gx HISTFILE $XDG_DATA_HOME/fish/fish_history

set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config
set -gx TREE_SITTER_DIR $XDG_CONFIG_HOME/tree-sitter

abbr --add dc cd
abbr --add fgfg fg

# Delete git remote branch tab completion.
# complete -f -c git -n '__fish_git_using_command checkout' \
#     -n 'not contains -- -- (commandline -opc)' \
#     -ka '(__fish_git_unique_remote_branches)' \
#     -d 'Unique Remote Branch'

# Up the open file limit.
if test "$OS" = Darwin
    ulimit -n unlimited
end
