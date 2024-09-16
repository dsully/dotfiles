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

set -gx FZF_DEFAULT_OPTS "--ansi --cycle --filepath-word --height=50% --info=hidden --layout=reverse-list --border=sharp $PICKER_COLORS"
set -gx FZF_DEFAULT_COMMAND "fd --type f --type l $FD_OPTIONS"
set -gx FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"
set -gx FZF_CTRL_T_COMMAND "fd --type f $FD_OPTIONS"

# Default arguments for file and grep pickers.
set -gx PICKER_ARGS --ansi \
    --bind "ctrl-/:toggle-preview" \
    --bind "ctrl-a:select-all+clear-screen+become(nvim {+})" \
    --bind "ctrl-d:deselect-all" \
    --bind "ctrl-k:preview-half-page-up" \
    --bind "ctrl-j:preview-half-page-down" \
    --bind "ctrl-r:toggle-sort" \
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

if status is-interactive

    if command -q fzf
        command fzf --fish | source

        bind ,ff __magic_enter_ff
        bind ,fg __magic_enter_fg
        bind ,fr __magic_enter_fr

    end
end
