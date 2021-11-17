function bu --description "Update Homebrew formula, casks and taps."
  command brew upgrade --formula
  command brew upgrade --casks (brew outdated --cask --greedy --quiet)
end
