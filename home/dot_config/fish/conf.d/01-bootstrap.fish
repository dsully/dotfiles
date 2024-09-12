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

set fish_greeting ''

fish_add_path -g \
    "$HOME/.cargo/bin" \
    "$HOME/.local/bin" \
    "$HOME/.local/go/bin" \
    "$HOME/.local/share/nvim/mason/bin" \
    "$HOME/.volta/bin"

# $XDG_CONFIG_HOME/fish/themes/nordish.fish
fish_config theme choose Nordish

# Set fisher and auto-generated .fish files to be outside of ~/.config/fish
# This will get picked up by $__fish_vendor_*
set -g fish_cache $XDG_CACHE_HOME/fish
set -U fisher_path $fish_cache

# Turn on vi keybindings
# set -g fish_key_bindings fish_vi_key_bindings
# set -g fish_key_bindings fish_hybrid_key_bindings
# bind --all \t accept-autosuggestion
bind --all \t complete
# https://github.com/fish-shell/fish-shell/issues/3299

set -gx HISTFILE $XDG_DATA_HOME/fish/fish_history

# Move Golang's path out of $HOME
set -gx GOPATH $HOME/.local/go
set -gx GO111MODULE on

set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config

# Node/Volta
set -gx NODE_REPL_HISTORY /dev/null
set -gx NO_UPDATE_NOTIFIER 1 # used by npm: https://github.com/yeoman/update-notifier/issues/180
set -gx VOLTA_HOME "$HOME/.volta"

# Silence direnv logging. Hook is invoked via vendor_conf.d/
set -gx DIRENV_LOG_FORMAT ""

# https://platform.openai.com/docs/models/gpt-4o
set -gx OPENAI_MODEL gpt-4o-2024-08-06

abbr --add dc cd

# Set `LS_COLORS` via https://github.com/sharkdp/vivid
if not string length --quiet $LS_COLORS; and command -q vivid
    set -Ux LS_COLORS (vivid generate nord)
end

# nord_dark_black '#2e3440'
# nord_black '#3b4252'
# nord_gray '#4c566a'
# nord_dark_white '#d8dee9'
# nord_blue '#81a1c1'
# nord_red '#bf616a'
# nord_green '#a3be8c'

# Set Nord as the fzf & skim color scheme: https://github.com/junegunn/fzf/blob/master/ADVANCED.md
set -gx PICKER_COLORS "--color=bg+:#3b4252,bg:#2e3440,spinner:#81a1c1,hl:#616e88,fg:#d8dee9,header:#616e88"
set -gx PICKER_COLORS "$PICKER_COLORS,info:#81a1c1,pointer:#bf616a,marker:#bf616a,fg+:#81a1c1,prompt:#81a1c1,hl+:#81a1c1"

# Delete git remote branch tab completion.
complete -e -f -c git -n '__fish_git_using_command checkout' \
    -n 'not contains -- -- (commandline -opc)' \
    -ka '(__fish_git_unique_remote_branches)' \
    -d 'Unique Remote Branch'
