function x -a file --description 'Extract archive'

    if command -q gtar
        set -f TAR gtar
    else
        set -f TAR tar
    end

    if test -x $HOMEBREW_PREFIX/opt/unzip/bin/unzip
        set -f UNZIP $HOMEBREW_PREFIX/opt/unzip/bin/unzip
    else if command -q unzip
        set -f UNZIP unzip
    end

    if test -f "$file"
        switch "$file"
            case "*.tar.bz2"
                $TAR xjf $file
            case "*.tar.gz"
                $TAR xzf $file
            case "*.bz2"
                bunzip2 $file
            case "*.rar"
                7z x $file
            case "*.gz"
                gunzip $file
            case "*.tar"
                $TAR xf $file
            case "*.tbz2"
                $TAR xjf $file
            case "*.tgz"
                $TAR xzf $file
            case "*.zip"
                $UNZIP $file
            case "*.Z"
                uncompress $file
            case "*.7z"
                7z x $file
            case "*"
                echo "'$file' cannot be extracted via x()"
        end
    else
        echo "Usage: extract [-option] [file ...]"
        return 1
    end
end
