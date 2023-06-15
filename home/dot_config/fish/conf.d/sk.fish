# https://github.com/lotabout/skim
if status is-interactive

    if type -q sk
        set -gx SKIM_DEFAULT_OPTIONS --height=30% $NORD_COLORS
        status --is-interactive; and skim_key_bindings
    end
end
