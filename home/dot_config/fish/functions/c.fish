function expand-slug --argument slug
    set url $slug

    if string match -q -r '^git@' $url
        echo $url
        return
    end

    # Handle github: prefix or plain owner/repo format
    if string match -q "github:/*" $slug

        # Remove github: prefix and add https://github.com/
        set url (string replace -r '^github:/+' 'https://github.com/' $slug)

    else if string match -q -r '^[^/]+/[^/]+$' $slug
        # Plain owner/repo format - add https://github.com/
        set url "https://github.com/$url"

    else if string match -q "github.com/*" $url; and not string match -q "*://*" $url
        # Handle github.com/owner/repo without protocol
        set url "https://$url"
    end

    echo $url
end

function repo-from-url --argument url --description="Extract just the repo name"
    basename $url | sed "s|.git\$||"
end

function c --wraps='git clone' --description 'Wrap git clone.' --argument url _destination cloneargs

    set url (expand-slug $url)

    set destination (default $_destination (repo-from-url $url))

    if test -e $destination
        echo 'Already cloned. Attempting pull...'
        cd $destination && git pull --rebase
        return
    end

    git clone $cloneargs $url $destination && cd $destination
end
