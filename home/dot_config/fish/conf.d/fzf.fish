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
    --bind 'ctrl-a:select-all+become(''nvim {+} > "$(command tty)")' \
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

function _fzf_grep --description 'Ripgrep and open files with fzf'
    argparse 'q/query=' 't/type=' -- $argv

    set FZF_DEFAULT_COMMAND rg --column --line-number --no-binary --no-heading
    set QUERY

    if test -n "$_flag_type"
        set FZF_DEFAULT_COMMAND $FZF_DEFAULT_COMMAND --type $_flag_type
    end

    if test -n "$_flag_query"
        set QUERY --query $_flag_query
    end

    fzf \
        $PICKER_ARGS \
        --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true" \
        --bind 'enter:become(''nvim {1}:{2}:{3} > "$(command tty)")' \
        --bind "start:reload:$FZF_DEFAULT_COMMAND '{q}'" \
        --delimiter : \
        --preview "_preview_file_content --path {1} --line {2} --column {3}" \
        $QUERY
end

function _preview_file_content --description 'Preview file content'
    argparse 'p/path=' 'l/line=' 'c/column=' -- $argv

    if not set -q _flag_path
        echo "Error: --path is required."
        return 1
    end

    set path $_flag_path
    set line $_flag_line
    set column $_flag_column

    set bat_args --color=always --plain

    if test -n "$line"
        set bat_args $bat_args --highlight-line $line

    else if test -n "$column"
        set bat_args $bat_args --highlight-line $line:$column
    else
        set bat_args $bat_args --line-range :50
    end

    switch $path
        case "*.md"
            # Use 'see' instead?
            command glow -s dark $path

        case "*.plist"
            command plutil -p $path

        case "*"
            set mime (command file -b --mime-type $path)

            switch $mime[1]
                case "text/*"
                    command bat $bat_args $path

                case application/json
                    command bat $bat_args -l json $path

                case image/{gif,jpeg,png,svg+xml,webp}
                    set -l TERM xterm-kitty
                    command viu $path

                case application/{gzip,java-archive,x-{7z-compressed,bzip2,chrome-extension,rar,tar,xar},zip}
                    command 7z l $path | command tail -n +12

                case "*"
                    command file -b $argv
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
