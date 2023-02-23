function ls --wraps=lsd

    # brew tap homebrew/cask-fonts
    # brew cask install font-hack-nerd-font
    # brew install lsd
    if type -q lsd
        command lsd $argv
    else
        command ls $argv
    end
end
