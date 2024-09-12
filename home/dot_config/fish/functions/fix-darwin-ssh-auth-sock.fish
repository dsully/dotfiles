function fix-darwin-ssh-auth-sock --description "Fix SSH_AUTH_SOCK on macOS"
    echo "SSH_AUTH_SOCK is $SSH_AUTH_SOCK"
    set uid (id -u "$USER")
    set target "gui/$uid/com.openssh.ssh-agent"

    if not set path (launchctl print "$target" | grep --max-count 1 --only-matching --regexp "/private/.*/Listeners")
        echo "Could not get path for SSH_AUTH_SOCK"
        return 1
    end

    echo "Sock path for target $target is $path"

    if [ "$path" = "$SSH_AUTH_SOCK" ]
        set_color green
        echo "SSH_AUTH_SOCK is already set to correct path"
        set_color normal
        return 0
    end

    set -x SSH_AUTH_SOCK "$path"

    if ssh-add -l
        echo "ssh-add -l ran successfully"
        return 0
    end

    echo "ssh-add -l did not run successfully"
    return 1
end
