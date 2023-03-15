# https://zellij.dev/ - terminal multiplexer and session manager.
if status is-interactive

    if type -q zellij
        if not test -f "$XDG_CONFIG_HOME/fish/completions/zellij.fish"
            zellij setup --generate-completion fish >"$XDG_CONFIG_HOME/fish/completions/zellij.fish"
        end

        # Automatically attach if a session doesn't exist.
        if not set -q ZELLIJ; and test -e "$XDG_CONFIG_HOME/zellij/auto"
            zellij attach -c $HOSTNAME
        end
    end
end
