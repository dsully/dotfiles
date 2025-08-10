function ,fi --description 'Inspect a process using lsof'
    __fzf_picker_args

    procs --no-header --color always $argv | fzf $PICKER_ARGS --nth=8 | awk '{print $1}' | while read -l pid
        command lsof -p $pid
    end
end
