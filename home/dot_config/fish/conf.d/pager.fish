if status is-interactive

    if type -q moar
        set -gx MOAR '-statusbar=bold -no-linenumbers -no-clear-on-exit -style=nord -colors=16M -wrap -quit-if-one-screen'
        set -gx PAGER moar
        set -gx MANPAGER moar

        abbr --add less moar

    else
        # Make less behave with XDG
        if not test -d "$XDG_CACHE_HOME/less"
            mkdir -p "$XDG_CACHE_HOME/less"
        end

        set -gx PAGER "less -FiRSwX"
        set -gx MANPAGER "less -FiRSwX"

        set -gx LESSKEY "$XDG_CACHE_HOME"/less/lesskey
        set -gx LESSHISTFILE /dev/null
    end
end
