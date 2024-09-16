# Open the Pull Request URL for your current directory's branch, merges by default against the current branch's parent
function git-openpr --description 'Open the Pull Request URL for your current directory'

    # https://gist.github.com/joechrysler/6073741
    set parent_branch_name (git_parent_branch)
    set current_branch_name (git rev-parse --abbrev-ref HEAD)

    set url (git remote -v | grep 'origin.*fetch' | awk '{print $2}')
    set url (string replace -r 'ssh://[^@]+@' 'https://' $url)
    set url (string replace -r 'git@github.com:' 'https://github.com/' $url | string replace '.git' '')

    set url $url"/compare/$parent_branch_name...$current_branch_name?expand=1"

    echo "Opening $url ..."

    command open --background $url
end
