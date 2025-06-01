function make --wraps='just'

    if test -f Makefile; or test -f makefile
        command make $argv

    else if test -f Justfile; or test -f justfile
        command just $argv
    else
        echo "No Makefile or Justfile found in the current directory."
        return 1
    end
end
