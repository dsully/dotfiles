function cat --wraps=bat --description 'Use bat instead of cat'

    # If no arguments are given, read from stdin.
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

    if contains $ext $markdown_extensions; and type -q see
        command see $argv[1]

    else if contains $ext $markdown_extensions; and type -q glow
        command glow --pager $argv[1]

    else if contains $ext ipynb; and type -q nbcat
        command nbcat $argv

    else if contains $ext $image_extensions; and type -q viu
        viu $argv
    else if type -q bat
        command bat $argv
    else
        command cat $argv
    end
end
