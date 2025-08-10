function ,fp -d "TCP Port Picker"

    __fzf_picker_args

    if command -q lsof
        lsof -iTCP -sTCP:LISTEN -n -P | sort | fzf --no-sort $PICKER_ARGS

    else if command -q ss
        # Linux with iproute2
        ss --listening --tcp --numeric | sort | fzf --no-sort $PICKER_ARGS

    else if command -q netstat
        # Fallback for systems without lsof or ss
        netstat -an -p tcp | grep LISTEN | sort | fzf --no-sort $PICKER_ARGS

    else
        echo "Error: No suitable command found (lsof, ss, or netstat)" >&2
        return 1
    end
end
