function topgrade -d "Topgrade wrapper."

    command topgrade --config $XDG_CONFIG_HOME/topgrade/default.toml $argv

    if test -f $XDG_CONFIG_HOME/topgrade/$HOSTNAME.toml
        command topgrade --config $XDG_CONFIG_HOME/topgrade/$HOSTNAME.toml $argv
    end
end
