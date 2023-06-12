function git-link --description "Switch between different git repositories for $HOME"

    if test (count $argv) -eq 0
        echo "Repository \"$argv[1]\" not found in $XDG_CONFIG_HOME/repos/"
        command ls $XDG_CONFIG_HOME/repos/

    else if test -e "$XDG_CONFIG_HOME/repos/$argv[1]"
        echo "gitdir: $XDG_CONFIG_HOME/repos/$argv[1]" >"$HOME/.git"
    end

end
