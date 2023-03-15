function cdr --description "chdir to the root of a git repo."
    cd (git rev-parse --show-toplevel 2>&1 /dev/null)
end
