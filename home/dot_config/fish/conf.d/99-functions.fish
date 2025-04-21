function fallback -d 'allow a fallback value for variable'
    if test (count $argv) = 1
        echo $argv
    else
        echo $argv[1..-2]
    end
end

function git_parent_branch
    set current_branch_name (git rev-parse --abbrev-ref HEAD)
    set parent_branch_name (git show-branch -a 2>/dev/null \
      | grep '\*' \
      | grep -v $current_branch_name \
      | head -n1 \
      | grep -o '\[[^]]*\]' \
      | head -1 \
      | tr -d '[]')

    echo $parent_branch_name
end
