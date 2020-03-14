# Defined in /var/folders/3q/x_nn53z13p35x0qrrx7n8bz40003dm/T//fish.OfVEf5/ls.fish @ line 2
function ls --wraps=/usr/local/bin/lsd --wraps=lsd
    
  # brew tap homebrew/cask-fonts
  # brew cask install font-hack-nerd-font
  # iTerm2 > Preferences > Profiles > Text > Non-ASCII-Font > Change Font
  command lsd $argv
end
