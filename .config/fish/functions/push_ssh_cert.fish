function push_ssh_cert --description "Push SSH public key to another box"

    test -f ~/.ssh/id_dsa.pub or ssh-keygen -t dsa

    for _host in $argv
      echo $_host
      ssh $_host 'cat >> ~/.ssh/authorized_keys2' < ~/.ssh/id_dsa.pub
  end
end
