if status is-interactive

    set -gx NODE_REPL_HISTORY /dev/null
    set -gx NO_UPDATE_NOTIFIER 1 # used by npm: https://github.com/yeoman/update-notifier/issues/180

    if type -q volta
        set -gx VOLTA_HOME "$HOME/.volta"

        fish_add_path -g $VOLTA_HOME/bin
    end
end
