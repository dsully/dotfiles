function __fzf_preview_file_content --description 'Preview file content'
    argparse 'p/path=' 'l/line=' 'c/column=' -- $argv

    if not set -q _flag_path
        echo "Error: --path is required."
        return 1
    end

    set path $_flag_path
    set line $_flag_line
    set column $_flag_column

    set bat_args --color=always --plain

    if test -n "$line"
        set bat_args $bat_args --highlight-line $line

    else if test -n "$column"
        set bat_args $bat_args --highlight-line $line:$column
    else
        set bat_args $bat_args --line-range :50
    end

    switch $path
        case "*.md"
            # Use 'see' instead?
            command glow -s dark $path

        case "*.plist"
            command plutil -p $path

        case "*"
            set mime (command file -b --mime-type $path)

            switch $mime[1]
                case application/json
                    command bat $bat_args -l json $path

                case image/{gif,jpeg,png,svg+xml,webp}
                    set -l TERM xterm-kitty
                    command viu $path

                case application/{gzip,java-archive,x-{7z-compressed,bzip2,chrome-extension,rar,tar,xar},zip}
                    command 7z l $path | command tail -n +12

                case "*"
                    command bat $bat_args $path
            end
    end
end
