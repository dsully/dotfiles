function bu --wraps="brew cu" --description "Update Homebrew formula, casks and taps."
  # command brew upgrade --fetch-HEAD --greedy
  command brew upgrade
  command brew cu --all --quiet --yes --cleanup --no-brew-update $argv
end
