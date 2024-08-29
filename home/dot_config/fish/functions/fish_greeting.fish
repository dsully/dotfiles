function fish_greeting
    status is-interactive || exit

    # brew install fastfetch
    if type -q fastfetch
        fastfetch
    end
end
