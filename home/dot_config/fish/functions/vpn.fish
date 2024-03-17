function vpn --description "Run a shell in the vpn network namespace"
    command doas /usr/sbin/ip netns exec vpn /bin/bash
end
