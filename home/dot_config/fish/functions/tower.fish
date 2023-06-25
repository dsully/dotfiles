function tower -d "Open Tower for directory (default: Git root)"

    if test $PWD = $HOME
        command open -a Tower "$XDG_DATA_HOME/chezmoi"
    else
        command open -a Tower (fallback $argv (git rev-parse --show-toplevel))
    end
end
