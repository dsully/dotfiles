function ,fr --description 'Fuzzy search and cd to a Git repository in ghq' --wraps ghq
    ghq list | fzf $PICKER_ARGS --tiebreak=index | perl -pe 'chomp if eof' | read line

    if [ $line ]
        ghq root | read dir
        cd "$dir/$line"
    end

    commandline -f repaint
end
