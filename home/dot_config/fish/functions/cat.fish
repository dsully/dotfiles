function cat --wraps=bat --description 'Use bat instead of cat'

    if isatty stdin; and not set -q argv[1]
        command cat -
        return
    end

    # https://sw.kovidgoyal.net/kitty/kittens/icat/
    # https://github.com/wez/wezterm/blob/main/docs/imgcat.md
    set -f image_extensions png jpg jpeg gif bmp tiff webp
    set -f markdown_extensions md markdown mkd
    set -f structured_extensions json yaml yml

    # Escape --version and similar.
    set -f ext (string split "." -- $argv[1])[-1]

    set -f md_exe type -q frogmouth; or type -q glow

    if contains $ext $markdown_extensions; and $md_exe

        # https://github.com/Textualize/frogmouth
        if command -q frogmouth
            frogmouth $argv[1]
        else if command -q glow
            glow -p $argv[1]
        end

    else if contains $ext $image_extensions; and test $TERM = xterm-ghostty
        viu $argv

    else if contains $ext $image_extensions; and test $TERM = xterm-kitty
        kitty +kitten icat $argv

    else if contains $ext $image_extensions; and command -q wezterm
        wezterm imgcat $argv

    else
        command bat $argv
    end
end
