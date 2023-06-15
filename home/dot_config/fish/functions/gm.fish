function gm --description 'Wrapper to handle git main/master'

    if not command git rev-parse --is-inside-work-tree >/dev/null 2>&1
        return
    end

    set -f name master
    set -f ref

    for ref in refs/{heads,remotes/{origin,upstream}}/{master,main,trunk,mainline,default}
        if command git show-ref -q --verify $ref
            set -f name (basename $ref)
            break
        end
    end

    command git switch -q $name
end
