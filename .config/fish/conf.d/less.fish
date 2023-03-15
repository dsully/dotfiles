# make less behave with XDG
if status is-interactive
    if not test -d "$XDG_CACHE_HOME/less"
        mkdir -p "$XDG_CACHE_HOME/less"
    end

    set -gx PAGER "less -FiRSwX"
    set -gx MANPAGER "less -FiRSwX"

    set -gx LESSKEY "$XDG_CACHE_HOME"/less/lesskey
    set -gx LESSHISTFILE "$XDG_CACHE_HOME"/less/history
end
