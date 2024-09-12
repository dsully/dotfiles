function ls --wraps='lsd' --description 'Wrap lsd'

    # brew install lsd / https://github.com/Peltoche/lsd
    if command -q lsd
        command lsd $argv
    else if command -q eza
        command eza $argv
    else
        command ls $argv
    end
end
