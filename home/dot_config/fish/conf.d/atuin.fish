# https://github.com/ellie/atuin
if status is-interactive; and command -q atuin
    set -gx ATUIN_SUPPRESS_TUI true

    atuin init fish | source
end
