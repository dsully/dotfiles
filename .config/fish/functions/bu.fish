function bu --wraps="brew cu" --description "Update Homebrew formula, casks and taps."
  command brew cu -a -q -y --no-quarantine $argv
end
