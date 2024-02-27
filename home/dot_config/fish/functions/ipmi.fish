function ipmi --description 'IPMI Connect'
    command ipmitool -H $argv[1] -U ADMIN -I lanplus sol info / activate
end
