if status is-interactive

    set -l startup $XDG_CONFIG_HOME/python/startup.py

    if test -f $startup
        set -gx PYTHONSTARTUP $startup
    end
end
