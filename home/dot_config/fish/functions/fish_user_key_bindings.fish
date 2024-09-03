function up
    prevd; and commandline -f repaint
end

function down
    # If no next item in forward history pick a new path.
    if test (count $dirnext) -eq 0
        set --local path $(fd -t d -d 2 . | fzf)
        and cd $path
        and commandline -f repaint
    else
        nextd; and commandline -f repaint
    end
end

function fish_user_key_bindings
    status is-interactive || exit

    bind \co up
    bind \cn down
end
