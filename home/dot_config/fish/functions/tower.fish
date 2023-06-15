function tower -d "Open Tower for directory (default: Git root)"
    command open -a Tower (fallback $argv (git rev-parse --show-toplevel))
end
