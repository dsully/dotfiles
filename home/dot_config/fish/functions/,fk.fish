function ,fk --description 'Kill a process by name'
    __fzf_picker_args

    procs --no-header --color always $argv | fzf $PICKER_ARGS --nth=8 | awk '{print $1}' | while read -l pid
        kill $pid
    end
end
