function gu --description 'Git pull and show log'

    set -l start (command git rev-parse HEAD)

    echo "Starting hash: $start"

    command git pull --rebase --autostash
    command git log $start..HEAD
end

