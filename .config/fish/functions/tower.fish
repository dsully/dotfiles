function tower -d "Open Tower for directory (default CWD)"
    open -a Tower (fallback $argv .)

    # alias tower="gittower (git rev-parse --show-toplevel)"
end
