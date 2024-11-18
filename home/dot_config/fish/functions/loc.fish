function loc --description 'Run scc with "--sort code" always' --wraps scc
    #
    # https://github.com/boyter/scc
    command scc \
        --exclude-ext Makefile \
        --exclude-ext json \
        --exclude-ext md \
        --exclude-ext svg \
        --exclude-ext toml \
        --exclude-ext yaml \
        --no-cocomo \
        --no-complexity \
        --no-gen \
        --no-size \
        --sort code \
        $argv
end
