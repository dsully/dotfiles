# https://github.com/lotabout/skim
if status is-interactive; and command -q sk

    set -gx SKIM_DEFAULT_OPTIONS "$SKIM_DEFAULT_OPTIONS --height=50% $PICKER_COLORS"

    # if type -q skim_key_bindings
    #     skim_key_bindings
    # end
end
