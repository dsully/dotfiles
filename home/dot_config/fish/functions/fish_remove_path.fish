function fish_remove_path
    if set -l index (contains -i "$argv" $fish_user_paths)
        set -e fish_user_paths[$index]
    end
end
