# Define these here instead of in functions/<command>.fish, so that rust-analyzer won't call it this way.
function clippy --wraps="cargo clippy" --description "Run clippy"
    cargo clippy --all-features --all-targets -- -Dclippy::all -Dunused_imports
end

function rfmt --wraps="cargo +nightly fmt" --description "Run rustfmt"
    cargo +nightly fmt --all $argv
end

function rcheck --wraps="cargo check" --description "Run cargo check"
    begin
        set_color blue
        echo -e "\n\nFormatting the code ...\n"
        set_color normal
        rust_fmt
    end &&
        begin
            set_color red
            echo -e "Running clippy...\n"
            set_color normal
            rust_clippy --all-features
        end &&
        begin
            set_color yellow
            echo -e "Running tests...\n"
            set_color normal
            cargo build --all-features && cargo nextest run --all-features --test-threads (nproc)
        end &&
        begin
            set_color purple
            echo -e "Testing the documentation...\n"
            set_color normal
            cargo doc --all-features
        end
end

if status is-interactive
    fish_add_path -g $HOME/.cargo/bin
end
