function ,fe -d "Environment Picker"

    __fzf_picker_args

    env | grep -vE '(LS_COLORS|__CF|XPC)' | sort | column -ts '=' | fzf --no-sort $PICKER_ARGS
end
