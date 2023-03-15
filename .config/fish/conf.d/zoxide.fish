# https://github.com/ajeetdsouza/zoxide
if status is-interactive

    if type -q zoxide
        zoxide init fish --cmd j | source

        set -gx _ZO_FZF_OPTS $FZF_DEFAULT_OPTS '--preview "_fzf_preview_file {}"'

        alias za "zoxide add"
        alias zq "zoxide query"
        alias zr "zoxide remove"
    end
end
