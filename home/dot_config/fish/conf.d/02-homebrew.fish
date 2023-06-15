if status is-interactive

    # Brew is installed in different places depending on OS and architecture.
    if not set -q HOMEBREW_PREFIX
        if test -d /opt/homebrew
            set -Ux HOMEBREW_PREFIX /opt/homebrew
        else if test -d /usr/local/Homebrew
            set -Ux HOMEBREW_PREFIX /usr/local
        else if test -d /home/linuxbrew/.linuxbrew
            set -Ux HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
        end
    end

    if set -q HOMEBREW_PREFIX

        # https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
        set -gx HOMEBREW_BAT 1
        set -gx HOMEBREW_CACHE $XDG_CACHE_HOME/brew
        set -gx HOMEBREW_CASK_OPTS --no-quarantine
        set -gx HOMEBREW_LOGS $XDG_CACHE_HOME/brew/logs
        set -gx HOMEBREW_NO_ANALYTICS 1
        set -gx HOMEBREW_NO_COMPAT 1
        set -gx HOMEBREW_NO_ENV_HINTS 1

        # Tell build tools about our special prefix
        if test $HOMEBREW_PREFIX != /usr/local
            set -gx CFLAGS -I$HOMEBREW_PREFIX/include
            set -gx CPPFLAGS -I$HOMEBREW_PREFIX/include
            set -gx LDFLAGS -L$HOMEBREW_PREFIX/lib
        end

        # https://github.com/Homebrew/homebrew-command-not-found
        builtin source $HOMEBREW_PREFIX/Library/Taps/homebrew/homebrew-command-not-found/handler.fish 2>/dev/null

        fish_add_path --append -g --move $HOMEBREW_PREFIX/{,s}bin
    end
end
