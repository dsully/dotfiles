function ,fr --description 'Fuzzy search and cd to a Git repository in ghq' --wraps ghq
    ghq list | fzf --ansi --height 40% --layout reverse-list --tiebreak index --info default | perl -pe 'chomp if eof' | read line

    if [ $line ]
        ghq root | read dir
        cd "$dir/$line"
    end

    commandline -f repaint
end

# https://kau.sh/blog/magic-enter-shell/
function __magic_enter_fr
    set -l cmd (commandline)
    commandline -f repaint
    if test -z "$cmd"
        commandline -r (,fr)
        commandline -f suppress-autosuggestion
    end
    commandline -f execute
end

bind ,fr __magic_enter_fr
