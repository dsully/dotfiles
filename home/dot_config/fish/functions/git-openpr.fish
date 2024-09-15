# Open the Pull Request URL for your current directory's branch, merges by default against the current branch's parent
function git-openpr --description 'Open the Pull Request URL for your current directory'
    set github_url (git remote -v | grep 'origin.*fetch' | awk '{print $2}' | sed -Ee 's#(git@|git://)#https://#' -e 's@com:@com/@' -e 's%\.git$%%' | awk '/github/')
    set current_branch_name (git rev-parse --abbrev-ref HEAD)

    # https://gist.github.com/joechrysler/6073741
    set parent_branch_name (git_parent_branch)

    # https://github.com/spatiallabs/spatial/compare/release-8.4...merge-PLAT-1234?expand=1
    command open $github_url"/compare/$parent_branch_name...$current_branch_name?expand=1"
end
