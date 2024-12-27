if status is-interactive

    if command -q go
        fish_add_path -g $HOME/.local/go/bin
    end
end
