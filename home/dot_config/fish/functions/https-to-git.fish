function https-to-git -a branch -d 'Change git remote URLs from HTTP(s) scheme to git://'

    set -q branch[1]; or set branch origin
    set -l url (git remote get-url --all $branch | sed -e 's|https://github\.com/|git@github.com:|')

    command git remote set-url $branch $url; and echo "changed git remote url for $branch to $url"
end
