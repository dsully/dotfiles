# 1Password shell integration.
if status is-interactive
    if type -q op
        set -gx OP_PLUGIN_ALIASES_SOURCED 1
        alias gh "op plugin run -- gh"
    end
end
