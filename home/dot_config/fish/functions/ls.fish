function ls --wraps='lsd' --description 'Wrap lsd'

    # Set `LS_COLORS` via https://github.com/sharkdp/vivid
    if not set -q LS_COLORS; and type -q vivid
        set -Ux LS_COLORS (vivid generate nord)
    end

    # https://github.com/Peltoche/lsd
    if type -q lsd
        command lsd $argv
    else
        command ls $argv
    end
end
