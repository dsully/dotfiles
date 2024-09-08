function arb --wraps autorebase -d "git pull and autorebase"
    autorebase --include-non-local --slow
end
