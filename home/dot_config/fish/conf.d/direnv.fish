if status is-interactive; and command -q direnv

    # Silence direnv logging. Hook is invoked via vendor_conf.d/
    set -gx DIRENV_LOG_FORMAT ""

    direnv hook fish | source
end
