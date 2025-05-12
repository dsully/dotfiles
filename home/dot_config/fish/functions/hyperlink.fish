function hyperlink -a uri text --description 'Print a OSC8 hyperlink'
    printf '\e]8;;%s\e\\\%s\e]8;;\e\\' $uri $text
end
