# Also use https://github.com/holmgr/cargo-sweep
if status is-interactive

    if type -q sccache
        set -gx RUSTC_WRAPPER sccache
    end
end
