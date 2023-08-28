if status is-interactive; and test $HOSTNAME = dsully-md1

    # Disable work's forced ssh-agent and use 1Password's ssh-agent instead.
    ssh-add -D -q
end
