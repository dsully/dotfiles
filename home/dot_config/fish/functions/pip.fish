function pip --wraps "uv pip"

    set red (set_color red)
    set reset (set_color normal)

    if type -q uv1
        command uv pip $argv
    else
        printf "%sError%s: Please install uv first.\n" $red $reset
    end
end
