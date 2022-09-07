if status is-interactive

# Brew is installed in different places depending on OS and architecture.
    if test -d /opt/homebrew
        set -Ux HOMEBREW_PREFIX /opt/homebrew
    else if test -d /usr/local/Homebrew
        set -Ux HOMEBREW_PREFIX /usr/local
    else if test -d /home/linuxbrew/.linuxbrew
        set -Ux HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
    end

    if set -q HOMEBREW_PREFIX

        # https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
        set -gx HOMEBREW_CASK_OPTS --no-quarantine
        set -gx HOMEBREW_BAT 1
        set -gx HOMEBREW_INSTALL_FROM_API 1
        set -gx HOMEBREW_NO_ANALYTICS 1
        set -gx HOMEBREW_NO_COMPAT 1
        set -gx HOMEBREW_NO_ENV_HINTS 1

        # https://github.com/Homebrew/homebrew-command-not-found
        set HANDLER Library/Taps/homebrew/homebrew-command-not-found/handler.fish

        if test -f "$HOMEBREW_PREFIX/$TAPS"
            source "$HOMEBREW_PREFIX/$TAPS"
        else if test -f "$HOMEBREW_PREFIX/Homebrew/$TAPS"
            source "$HOMEBREW_PREFIX/Homebrew/$TAPS"
        end

        fish_add_path --append "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"
    end
end
