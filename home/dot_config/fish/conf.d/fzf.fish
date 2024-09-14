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

set -gx FD_OPTIONS "--hidden --follow --exclude .git"

set -gx FZF_DEFAULT_OPTS "--cycle --filepath-word --height=50% --info=hidden --border=sharp $PICKER_COLORS"
set -gx FZF_DEFAULT_COMMAND "fd --type f --type l $FD_OPTIONS"
set -gx FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"

# Default arguments for file and grep pickers.
set -gx PICKER_ARGS --ansi \
    --bind "ctrl-/:toggle-preview" \
    --bind "ctrl-a:select-all+clear-screen+become(nvim {+})" \
    --bind "ctrl-d:deselect-all" \
    --bind "ctrl-y:execute-silent(echo -n {} | pbcopy)+clear-screen+abort" \
    --border=sharp \
    --cycle \
    --delimiter : \
    --disabled \
    --height=100% \
    --info=default \
    --layout=reverse-list \
    --margin=5% \
    --multi \
    --no-clear \
    --no-scrollbar \
    --preview-window 'up,50%,wrap,border-bottom,+{2}/3'

if functions -q fzf_configure_bindings
    # set fzf_preview_file_cmd bat --line-range :100 --color=always --plain

    set fzf_preview_file_cmd __fzf_preview_file_content
    set fzf_preview_dir_cmd lsd --color always --icon always --almost-all --oneline --classify

    # Edit with nvim on search-directory
    set fzf_directory_opts --bind "ctrl-e:execute($EDITOR {} &> /dev/tty)"

    # Exclude the command timestamp from the search scope when in Search History
    set fzf_history_opts "--nth=4.."

    set fzf_fd_opts --hidden
    set fzf_dir_opts --bind 'ctrl-e:execute(command $EDITOR {} >/dev/tty)'

    # Bind Ctrl-t to use fzf for the current directory.
    fzf_configure_bindings --directory=\ct

    # Bind Ctrl-h for cd history
    bind \ch fzf_path_history
end

function fzf_path_history --description 'cd to one of the previously visited locations'
    if set -q argv[1]
        cd $argv
        return
    end

    set -l all_dirs $dirprev $dirnext

    if not set -q all_dirs[1]
        return 0
    end

    # Reverse the directories so the most recently visited is first in the list and eliminate duplicates.
    set -l uniq_dirs

    for dir in $all_dirs[-1..1]
        if test -d $dir -a "$dir" != "$PWD"
            if not contains $dir $uniq_dirs
                set -a uniq_dirs $dir
            end
        end
    end

    set result (string join \n $uniq_dirs | fzf --multi --reverse --tiebreak=index --toggle-sort=ctrl-r $FZF_DEFAULT_OPTS)

    if test -d "$result"
        cd $result
    end

    commandline -f repaint
end
