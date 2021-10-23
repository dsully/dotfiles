function rsync --wraps=rsync
    # -P == --partial --progress
    # -X == extended attrs, -E == executable -A == acls  --fake-super == store priv attrs
    # -a --no-i-r --info=progress2
    # --compress-choice=zstd --compress-level=3 --checksum-choice=xxh3
    command /usr/local/bin/rsync -a --no-i-r --info=progress2 --exclude '*.pyc' --exclude __pycache__ --compress-choice=zstd --compress-level=3 --checksum-choice=xxh3 $argv
end
