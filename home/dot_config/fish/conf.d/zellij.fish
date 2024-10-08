# https://zellij.dev/ - terminal multiplexer and session manager.
if status is-interactive; and command -q zellij

    # Update the zellij tab name with the current pwd.
    # https://github.com/zellij-org/zellij/issues/2284
    if set -q ZELLIJ
        function zellij_tab_name_update --on-variable PWD
            command nohup zellij action rename-tab (prompt_pwd) >/dev/null 2>&1
        end
    end

    # Automatically attach if a session doesn't exist.
    if not set -q ZELLIJ; and test -e "$XDG_CONFIG_HOME/zellij/auto"
        zellij attach -c $HOSTNAME
    end

end
