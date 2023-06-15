function cat --wraps=bat --description 'Use bat instead of cat'

    if isatty stdin; and not set -q argv[1]
        command cat -
        return
    end

    # https://sw.kovidgoyal.net/kitty/kittens/icat/
    # https://github.com/wez/wezterm/blob/main/docs/imgcat.md
    set -f image_extensions png jpg jpeg gif bmp tiff webp
    set -f markdown_extensions md markdown mkd

    # Escape --version and similar.
    set -f ext (string split "." -- $argv[1])[-1]

    if contains $ext $markdown_extensions

        if type -q frogmouth
            frogmouth $argv[1]
        else if type -q glow
            glow -p $argv[1]
        else
            echo "Neither 'frogmouth' nor 'glow' is installed for Markdown rendering."
        end

    else if contains $ext $image_extensions; and test $TERM = xterm-kitty
        kitty +kitten icat $argv[1]

    else if contains $ext $image_extensions; and type -q wezterm
        wezterm imgcat $argv[1]

    else
        command bat --style plain --theme Nord --pager=$PAGER $argv
    end
end
