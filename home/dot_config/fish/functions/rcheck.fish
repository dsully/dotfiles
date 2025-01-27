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
