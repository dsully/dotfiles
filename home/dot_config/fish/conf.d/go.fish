if status is-interactive

    if command -q go
        fish_add_path -g $HOME/.local/go/bin

        # Move Golang's path out of $HOME
        set -gx GOPATH $HOME/.local/go
        set -gx GO111MODULE on
    end
end
