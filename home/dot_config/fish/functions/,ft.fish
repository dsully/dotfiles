function ,ft

    if test (count $argv) -lt 2
        echo "Usage: ,ft <filetype> <query>"
        return 1
    end

    set -l FZF_DEFAULT_COMMAND rg --column --line-number --no-binary --no-heading --type $argv[1]

    fzf \
        $PICKER_ARGS \
        --bind "change:reload:$FZF_DEFAULT_COMMAND {q} || true" \
        --bind 'enter:become(''nvim {1}:{2}:{3} > "$(command tty)")' \
        --bind "start:reload:$FZF_DEFAULT_COMMAND '{q}'" \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --print-query \
        --query $argv[2..]
end
