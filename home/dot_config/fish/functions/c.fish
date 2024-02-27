# Defined in /var/folders/g9/zpcnvdcj0h75srmx90gqwmkw0003dm/T//fish.qjzY3d/c.fish @ line 1
function c --wraps='git clone' --description 'Wrap git clone.'

    set path (basename $argv[1] | sed 's/.git$//')
    set count (count $argv)

    if test $count -eq 2
        set path $argv[2]
    end

    command git clone $argv[1] $path
    cd $path
end
