# https://github.com/ajeetdsouza/zoxide
if status is-interactive

    if command -q zoxide
        set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS \
            --bind=ctrl-z:ignore \
            --exit-0 \
            --inline-info \
            --layout reverse-list \
            --preview "_fzf_preview_file {+}" \
            --no-sort \
            --select-1

        zoxide init fish --cmd j | source
    end
end
