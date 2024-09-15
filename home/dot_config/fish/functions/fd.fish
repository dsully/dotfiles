function fd --wraps fd
    command fd --full-path --hidden $argv
end
