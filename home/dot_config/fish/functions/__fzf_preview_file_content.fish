function __fzf_preview_file_content
    switch $argv
        case "*.md"
            glow -s dark $argv
        case "*.plist"
            plutil -p $argv
        case "*"
            set bat_args --line-range :100 --color=always --plain

            set mime (file -b --mime-type $argv)

            switch $mime[1]
                case "text/*"
                    bat $bat_args $argv
                case application/json
                    bat $bat_args -l json $argv
                case image/{gif,jpeg,png,svg+xml,webp}
                    TERM=xterm-kitty viu $argv
                case application/{msword,vnd.{ms-excel,ms-powerpoint},pdf} image/{heic,x-icns}
                    # set tmp (mktemp -d)
                    # qlmanage -t -s (math $COLUMNS x 8) -o $tmp $argv &>/dev/null
                    # preview $tmp/*
                    # rm -r $tmp
                    file -b $argv
                    echo "($mime[1])"
                case application/{gzip,java-archive,x-{7z-compressed,bzip2,chrome-extension,rar,tar,xar},zip}
                    7z l $argv | tail -n +12
                case "*"
                    file -b $argv
                    echo "($mime[1])"
            end
    end
end
