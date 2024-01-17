function open-urls -a file -d "Open a file with URLs."

    for url in (cat $file)
        command /usr/bin/open $url
    end
end
