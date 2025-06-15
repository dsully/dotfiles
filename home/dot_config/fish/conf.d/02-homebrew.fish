# Brew is installed in different places depending on OS and architecture.
if status is-interactive

    if test -d /opt/homebrew
        set -gx HOMEBREW_PREFIX /opt/homebrew

        # https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
        set -gx HOMEBREW_BAT 1
        set -gx HOMEBREW_BUNDLE_FILE $XDG_CONFIG_HOME/Brewfile
        set -gx HOMEBREW_BUNDLE_NO_LOCK 1
        set -gx HOMEBREW_CACHE $XDG_CACHE_HOME/brew
        set -gx HOMEBREW_CASK_OPTS --no-quarantine
        set -gx HOMEBREW_LOGS $XDG_CACHE_HOME/brew/logs
        set -gx HOMEBREW_NO_ANALYTICS 1
        set -gx HOMEBREW_NO_COMPAT 1
        set -gx HOMEBREW_NO_ENV_HINTS 1

        set -gx DYLD_LIBRARY_PATH $HOMEBREW_PREFIX/lib

        fish_add_path --append -g --move $HOMEBREW_PREFIX/{,s}bin

        if not contains $HOMEBREW_PREFIX/share/info $INFOPATH
            set -gx INFOPATH $HOMEBREW_PREFIX/share/info $INFOPATH
        end
    end
end
