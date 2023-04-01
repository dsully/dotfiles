function cat --wraps=bat --description 'Use bat instead of cat'

    if isatty stdin; and not set -q argv[1]
        command cat -
        return
    end

    # https://sw.kovidgoyal.net/kitty/kittens/icat/
    # https://github.com/wez/wezterm/blob/main/docs/imgcat.md
    set -f icat_extensions png jpg jpeg gif bmp tiff webp
    set -f glow_extensions md markdown mkd text txt

    # Escape --version and similar.
    set -f ext (string split "." -- $argv[1])[-1]

    if contains $ext $glow_extensions
        glow -p $argv[1]

    else if contains $ext $icat_extensions; and test $TERM = xterm-kitty
        kitty +kitten icat $argv[1]

    else if contains $ext $icat_extensions; and type -q wezterm
        wezterm imgcat $argv[1]

    else
        command bat --style plain --theme Nord --pager="/usr/bin/less -RFX" $argv
    end
end
