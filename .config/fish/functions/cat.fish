# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.DnKdnn/cat.fish @ line 2
function cat --wraps=bat --description 'Use bat instead of cat'

    if isatty stdin; and not set -q argv[1]
        command cat -
        return
    end

    # https://sw.kovidgoyal.net/kitty/kittens/icat/
    set -f icat_extensions png jpg gif bmp tiff webp
    set -f glow_extensions md markdown mkd text txt

    # Escape --version and similar.
    set -f arg (string replace -r '^-' '\-')

    set -f ext (string split "." $arg)[-1]

    if contains $ext $glow_extensions
        glow -p $argv[1]

    else if contains $ext $icat_extensions; and type -q kitty
        kitty +kitten icat $argv[1]
    else
        command bat --style plain --theme Nord $argv
    end
end
