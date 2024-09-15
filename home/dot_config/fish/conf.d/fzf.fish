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

set -gx FD_OPTIONS "--color always --hidden --follow --exclude .git"

set -gx FZF_DEFAULT_OPTS "--cycle --filepath-word --height=50% --info=hidden --border=sharp $PICKER_COLORS"
set -gx FZF_DEFAULT_COMMAND "fd --type f --type l $FD_OPTIONS"
set -gx FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"

# Default arguments for file and grep pickers.
set -gx PICKER_ARGS --ansi \
    --bind "ctrl-/:toggle-preview" \
    --bind "ctrl-a:select-all+clear-screen+become(nvim {+})" \
    --bind "ctrl-d:deselect-all" \
    --bind "ctrl-k:preview-half-page-up" \
    --bind "ctrl-j:preview-half-page-down" \
    --bind "ctrl-s:toggle-sort" \
    --bind "ctrl-y:execute-silent(echo -n {} | pbcopy)+clear-screen+abort" \
    --border=sharp \
    --cycle \
    --height=100% \
    --info=default \
    --layout=reverse-list \
    --margin=5% \
    --multi \
    --no-clear \
    --no-scrollbar \
    --preview-window 'up,50%,wrap,border-bottom,+{2}/3'

if functions -q fzf_configure_bindings
    set fzf_preview_file_cmd _preview_file_content
    set fzf_preview_dir_cmd lsd --color=always --icon=always --almost-all --oneline --classify --tree

    # Edit with nvim on search-directory
    set fzf_directory_opts $PICKER_ARGS --bind "ctrl-e:execute($EDITOR {} &> /dev/tty)"

    # Exclude the command timestamp from the search scope when in Search History
    set fzf_history_opts $PICKER_ARGS --nth=4..

    # Bind Ctrl-t to use fzf for the current directory.
    fzf_configure_bindings --directory=\ct
end

function _preview_file_content
    set -f path $argv[1]
    set -f bat_args --color=always --plain --line-range :100

    if test (count $argv) -gt 1
        set -f bat_args --color=always --plain --highlight-line $argv[2]
    end

    switch $path
        case "*.md"
            glow -s dark $path
        case "*.plist"
            plutil -p $path
        case "*"
            set mime (file -b --mime-type $path)

            switch $mime[1]
                case "text/*"
                    bat $bat_args $path
                case application/json
                    bat $bat_args -l json $path
                case image/{gif,jpeg,png,svg+xml,webp}
                    TERM=xterm-kitty viu $argv
                case application/{msword,vnd.{ms-excel,ms-powerpoint},pdf} image/{heic,x-icns}
                    # set tmp (mktemp -d)
                    # qlmanage -t -s (math $COLUMNS x 8) -o $tmp $argv &>/dev/null
                    # preview $tmp/*
                    # rm -r $tmp
                    file -b $path
                    echo "($mime[1])"
                case application/{gzip,java-archive,x-{7z-compressed,bzip2,chrome-extension,rar,tar,xar},zip}
                    7z l $path | tail -n +12
                case "*"
                    file -b $argv
                    echo "($mime[1])"
            end
    end
end

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

bind ,ff __magic_enter_ff
bind ,fg __magic_enter_fg
bind ,fr __magic_enter_fr
