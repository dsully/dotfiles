if status is-interactive

    if command -q moor
        set -gx PAGER moor
        set -gx MOOR "-statusbar bold -no-linenumbers -no-clear-on-exit -style nord -colors 16M -wrap -quit-if-one-screen"

        if command -q bat
            set -gx BAT_PAGER 'moor -no-linenumbers -quit-if-one-screen'
        end

    else if command -q ov
        set -gx PAGER "ov --exit-write --quit-if-one-screen"

    else
        # Make less behave with XDG
        if not test -d "$XDG_CACHE_HOME/less"
            mkdir -p "$XDG_CACHE_HOME/less"
        end

        set -gx PAGER "less -FiRSwX"
        set -gx LESSKEY "$XDG_CACHE_HOME"/less/lesskey
        set -gx LESSHISTFILE /dev/null
    end

    set -gx BAT_THEME Nord
    set -gx MANPAGER $PAGER
end
