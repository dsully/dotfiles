function bu --description "Update Homebrew formula, casks and taps."
  command brew update --force
  command brew upgrade --greedy --force-bottle
  command brew cleanup --prune=all
end
