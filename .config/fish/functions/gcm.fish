function gcm --wraps="git checkout" -d "git checkout master"
    command git checkout master $argv
end
