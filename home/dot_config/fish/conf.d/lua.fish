if status is-interactive

    if type -q luarocks
        fish_add_path -g $HOME/.luarocks/bin
    end
end
