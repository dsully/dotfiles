function seecert --description "See the certificate for a domain"
    command q A AAAA $argv[1]
    echo
    command step certificate inspect --short https://$argv[1]
end
