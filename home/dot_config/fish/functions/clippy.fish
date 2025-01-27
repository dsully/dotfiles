function clippy --wraps="cargo clippy" --description "Run clippy"
    command cargo clippy --all-features --all-targets -- \
        --no-deps \
        -Wclippy::complexity \
        -Wclippy::correctness \
        -Wclippy::pedantic \
        -Wclippy::perf \
        -Wclippy::style \
        -Wclippy::suspicious \
        -Aclippy::doc_markdown \
        -Aclippy::missing_errors_doc \
        -Aclippy::missing_panics_doc
end
