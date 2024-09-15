function gpr --description 'Run git push and then immediately open the Pull Request URL'
    git push origin HEAD

    if test $status -eq 0
        git-openpr
    else
        echo 'failed to push commits and open a pull request.'
    end
end
