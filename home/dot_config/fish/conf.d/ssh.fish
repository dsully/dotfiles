if status is-interactive; and string match -q 'dsully-*' "$HOSTNAME"

    # Disable work's forced ssh-agent and use 1Password's ssh-agent instead.
    ssh-add -D -q
end
