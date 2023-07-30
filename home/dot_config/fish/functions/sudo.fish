function sudo -d "doas wrapper."

    argparse --ignore-unknown h/help i/login n/non_interactive s/shell u/user= -- $argv

    if set -q _flag_help
        echo """Usage:
  sudo (-i | -s) [-n] [-u <user>] [<command> [--] [<args>...]]
  sudo [-ins] [-u <user>] <command> [--] [<args>...]
  sudo [-h]

Execute a command as another user using doas(1).

This is not the original sudo, but the doas shim for sudo. It supports only
a subset of the sudo options (both short and long) that have an equivalent in
doas, plus option -i (--login). Refer to sudo(1) for more information.

Based on <https://github.com/jirutka/doas-sudo-shim/issues>.
""" >&2

        return
    end

    if set -q _flag_non_interactive
        set -f _flag_non_interactive -n
    end

    if set -q _flag_user
        set -f _flag_user -u $_flag_user
    end

    if set -q $_flag_non_interactive; and set -q _flag_shell
        echo "sudo: you may not specify both the '-i' and '-s' options" >&2
        exit 1
    end

    set -x SUDO_GID (id -g)
    set -x SUDO_UID (id -u)
    set -x SUDO_USER (id -un)

    set -l USER_SHELL (getent passwd $user or "root" | awk -F: '{print $NF}')

    if test (count $argv) -eq 0
        if set -q _flag_i
            command doas $_flag_non_interactive $_flag_user $USER_SHELL -c "cd $HOME; exec $SHELL -l"
        else
            command doas $_flag_non_interactive $_flag_user -s
        end

    else if set -q _flag_non_interactive
        command doas $_flag_non_interactive $_flag_user $USER_SHELL -l -c "cd $HOME; $SHELL $argv"

    else if set -q _flag_shell
        command doas $_flag_non_interactive $_flag_user $USER_SHELL -c "$SHELL $argv"
    else
        command doas $_flag_non_interactive $_flag_user $argv
    end
end
