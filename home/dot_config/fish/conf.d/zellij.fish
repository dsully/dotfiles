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
        command zellij attach -c $HOSTNAME
    end

    # https://github.com/zellij-org/zellij/discussions/2889
    function zellij_update_tabname
        if set -q ZELLIJ
            set current_dir $PWD

            if test $current_dir = $HOME
                set tab_name "~"
            else
                set tab_name (basename $current_dir)
            end

            if fish_git_prompt >/dev/null
                set git_root (git rev-parse --show-superproject-working-tree)

                if test -z "$git_root"
                    set git_root (git rev-parse --show-toplevel)
                end

                # If we are in a subdirectory of the git root, use the relative path
                if test (string lower "$git_root") != (string lower "$current_dir")
                    set tab_name (basename $git_root)/(basename $current_dir)
                end
            end

            command nohup zellij action rename-tab $tab_name >/dev/null 2>&1
        end
    end

    # Auto update tab name on directory change
    #
    # function __zellij_update_tabname --on-variable PWD --description "Update zellij tab name on directory change"
    #     zellij_update_tabname
    # end

    function __fish_update_zellij_tabname_prompt --on-event fish_prompt
        if set -q ZELLIJ
            zellij action rename-tab "fish $(prompt_pwd)"
        end
    end

    function __fish_update_zellij_tabname_preexec --on-event fish_preexec
        if set -q ZELLIJ
            set cmd "$(string split " " $argv[1])"
            zellij action rename-tab "$cmd $(prompt_pwd)"
        end
    end
end
