if status is-login

    if test $OS = Linux
        abbr sc "doas systemctl"
        abbr uc "systemctl --user"
        abbr sj "journalctl --all --follow --unit"
        abbr uj "journalctl --all --follow --user-unit"
    end
end
