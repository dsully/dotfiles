function fish_greeting
    status is-interactive || exit

    # brew install fastfetch
    if command -q fastfetch
        fastfetch
    end
end
