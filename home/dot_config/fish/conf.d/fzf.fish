# https://github.com/PatrickF1/fzf.fish
#
# nord_dark_black '#2e3440'
# nord_black '#3b4252'
# nord_gray '#4c566a'
# nord_dark_white '#d8dee9'
# nord_blue '#81a1c1'
# nord_red '#bf616a'
# nord_green '#a3be8c'

# Set Nord as the fzf & skim color scheme: https://github.com/junegunn/fzf/blob/master/ADVANCED.md
set -gx PICKER_COLORS "--color=bg+:#3b4252,bg:#2e3440,spinner:#81a1c1,hl:#616e88,fg:#d8dee9,header:#616e88,border:#4c566a"
set -gx PICKER_COLORS "$PICKER_COLORS,info:#81a1c1,pointer:#bf616a,marker:#bf616a,fg+:#81a1c1,prompt:#81a1c1,hl+:#81a1c1"

set -gx FD_OPTIONS "--color always --hidden --follow --exclude .git --one-file-system"

set -gx FZF_DEFAULT_OPTS "--ansi --cycle --filepath-word --height=50% --info=hidden --layout=reverse-list --border=sharp $PICKER_COLORS"
set -gx FZF_DEFAULT_COMMAND "fd --type f --type l $FD_OPTIONS"
set -gx FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"
set -gx FZF_CTRL_T_COMMAND "fd --type f $FD_OPTIONS"

# Set up magic enter functions: https://kau.sh/blog/magic-enter-shell/
function __magic_enter_ff
    set -l cmd (commandline)
    commandline -f repaint

    if test -z "$cmd"
        commandline -r (,ff)
        commandline -f suppress-autosuggestion
    end

    commandline -f execute
end

function __magic_enter_fg
    set -l cmd (commandline)
    commandline -f repaint

    if test -z "$cmd"
        commandline -r (,fg)
        commandline -f suppress-autosuggestion
    end

    commandline -f execute
end

function __magic_enter_fr
    set -l cmd (commandline)
    commandline -f repaint

    if test -z "$cmd"
        commandline -r (,fr)
        commandline -f suppress-autosuggestion
    end

    commandline -f execute
end

if status is-interactive

    if command -q fzf
        command fzf --fish | source

        bind ,ff __magic_enter_ff
        bind ,fg __magic_enter_fg
        bind ,fr __magic_enter_fr

    end
end
