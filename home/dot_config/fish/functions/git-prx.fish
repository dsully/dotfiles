function git-prx --description "Interactively select and checkout a GitHub PR"
    set choices (gh pr list $argv --json author,title,number --jq '.[] | "#\(.number): \(.title) (@\(.author.login))"')

    if test -z "$choices"
        return 0
    end

    set choice (echo $choices | fzf --prompt="Select PR > ")
    set choice (echo $choice | cut -d' ' -f1 | tr -d '#:')

    if test -z "$choice"
        return 0
    end

    gh pr checkout $choice
end
