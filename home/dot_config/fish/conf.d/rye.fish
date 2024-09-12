# https://rye-up.com
if status is-interactive

    if test -d $HOME/.rye
        set -gx RYE_HOME $HOME/.rye
        fish_add_path -g $RYE_HOME/shims
    end
end
