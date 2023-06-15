# https://github.com/ellie/atuin
if status is-interactive

    if type -q atuin
        set -gx ATUIN_SUPPRESS_TUI true

        atuin init fish | source
    end
end
