function rsync --wraps=rsync
    # -P == --partial --progress
    # -X == extended attrs, -E == executable -A == acls  --fake-super == store priv attrs
    # -a --no-i-r --info=progress2
    command rsync -az --no-i-r --info=progress2 --exclude '*.pyc' --exclude __pycache__ $argv
end
