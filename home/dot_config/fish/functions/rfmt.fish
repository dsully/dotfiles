function rfmt --wraps="cargo +nightly fmt" --description "Run rustfmt"
    cargo +nightly fmt --all $argv
end
