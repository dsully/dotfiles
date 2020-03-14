function gca --wraps="git commit" -d "git commit amend"
    command git commit --amend $argv
end
