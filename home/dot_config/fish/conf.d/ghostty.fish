if status is-interactive; and test -n "$GHOSTTY_RESOURCES_DIR"

    set -p fish_complete_path (path resolve "$GHOSTTY_RESOURCES_DIR/../fish/vendor_completions.d")

    # Set up Ghostty's shell integration.
    source $GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
end
