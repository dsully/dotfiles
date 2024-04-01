function c --wraps='git clone' --description 'Wrap git clone.'

    set path (basename $argv[1] | sed 's/.git$//')
    set count (count $argv)

    if test $count -eq 2
        set path $argv[2]
    end

    command git clone $argv[1] $path
    cd $path
end
