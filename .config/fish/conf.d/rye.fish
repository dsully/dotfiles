# https://rye-up.com
if status is-interactive

    if test -d $HOME/.rye
        set -gx RYE_HOME $HOME/.rye
    end

    if test -d $RYE_HOME/shims
        fish_add_path --append -g $RYE_HOME/shims
    end
end
