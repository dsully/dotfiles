function wget --wraps=curl
    command curl --location -O $argv
end
