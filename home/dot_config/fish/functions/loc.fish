function loc --description 'Run tokei with "--sort code" always' --wraps tokei
    command tokei --sort code $argv
end
