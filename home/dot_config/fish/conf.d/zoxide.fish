# https://github.com/ajeetdsouza/zoxide
if status is-interactive

    if command -q zoxide
        set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS \
            --bind=ctrl-z:ignore \
            --exit-0 \
            --info=default \
            --layout=reverse-list \
            --no-sort \
            --select-1

        zoxide init fish --cmd j | source
    end
end
