# https://github.com/ajeetdsouza/zoxide
if status is-interactive; and command -q zoxide

    set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS \
        --bind=ctrl-z:ignore \
        --exit-0 \
        --info=default \
        --layout=reverse-list \
        --no-sort \
        --select-1

    # Cache zoxide init output
    set cache $XDG_CACHE_HOME/fish/conf.d/zoxide.fish

    source $cache 2>/dev/null; or begin
        zoxide init fish --cmd j >$cache
        source $cache
    end
end
