function podman --wraps=podman -d "podman sudo wrapper"

    if type -q doas
        command doas podman $argv
    else
        command sudo podman $argv
    end
end
