# Also use https://github.com/holmgr/cargo-sweep
if status is-interactive

    # https://doc.rust-lang.org/cargo/reference/environment-variables.html
    set -gx CARGO_NET_GIT_FETCH_WITH_CLI true

    if type -q sccache
        set -gx RUSTC_WRAPPER sccache
    end
end
