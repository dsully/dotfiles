function ,fj --description 'Fuzzy Jump'

    set -f token (commandline --current-token)
    set -f selection (command zoxide query --interactive $token 2> /dev/null)

    if test $status -eq 0
        cd $selection
        # commandline --current-token --replace -- (string escape -- $selection | string join ' ')
    end

    # commandline --function repaint
end
