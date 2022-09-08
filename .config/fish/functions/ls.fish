function ls --wraps=lsd

    set COMMAND /bin/ls

    # brew tap homebrew/cask-fonts
    # brew cask install font-hack-nerd-font
    # brew install lsd
    if test -q "$HOMEBREW_PREFIX/lsd"
        set COMMAND "$HOMEBREW_PREFIX/lsd"
    end

    command $COMMAND $argv
end
