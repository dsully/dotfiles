function ls --wraps=/usr/local/bin/lsd --wraps=lsd

    # brew tap homebrew/cask-fonts
    # brew cask install font-hack-nerd-font
    switch $OS
        case Darwin
            command /usr/local/bin/lsd $argv
        case Linux
            command /usr/bin/lsd $argv
    end
end
