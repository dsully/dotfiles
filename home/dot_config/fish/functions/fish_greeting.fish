function fish_greeting
    status is-interactive || exit

    # brew install macchina
    if command -q macchina
        macchina
    end
end
