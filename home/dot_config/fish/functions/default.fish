function default --argument val default
    if test -n "$val"
        echo $val
    else
        echo $default
    end
end
