function bu --description "Update Homebrew formula, casks and taps."
  command brew upgrade --formula --force-bottle
  command brew upgrade --casks (brew outdated --cask --quiet)
end
