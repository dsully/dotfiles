function ensure-rust-analyzer
    set MANDATORY_COMPONENTS clippy rust-analyzer

    for toolchain in (rustup toolchain list | awk '{print $1}')
        echo "==> Installing mandatory components for $toolchain"

        for component in $MANDATORY_COMPONENTS
            rustup component add $component --toolchain $toolchain
        end
    end
end
