# https://github.com/PatrickF1/fzf.fish

set -gx FZF_DEFAULT_OPTS --cycle --filepath-word --height=50% --info=hidden --border=sharp $NORD_COLORS

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
