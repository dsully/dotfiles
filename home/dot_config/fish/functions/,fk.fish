function ,fk --description 'Kill a process by name'
    procs --no-header -c always | fzf --ansi | awk '{print $1}' | while read -l pid
        kill $pid
    end
end
