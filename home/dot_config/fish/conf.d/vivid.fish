# Set `LS_COLORS` via https://github.com/sharkdp/vivid
if status is-interactive; and command -q vivid

    set -gx LS_COLORS (vivid generate nord)
end
