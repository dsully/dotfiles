if status is-interactive; and test -n "$GHOSTTY_RESOURCES_DIR"

    # Set up Ghostty's shell integration.
    source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
end
