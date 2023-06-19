#!/bin/sh -e

if ! command -v chezmoi >/dev/null; then
    bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
    chezmoi="$bin_dir/chezmoi"

    chezmoi_url="https://www.chezmoi.io/get"

    if command -v curl >/dev/null; then
        curl -sSf "$chezmoi_url" | sh -s -- -b "$bin_dir"
    else
        echo "To install chezmoi, you must have curl installed." >&2
        exit 1
    fi
else
    chezmoi=chezmoi
fi

# Attach to a TTY for input prompting.
stdin='/dev/null'

if [ "$(ps otty= $$)" != '?' ]; then
    stdin='/dev/tty'
fi

"$chezmoi" init --apply --exclude encrypted "$@" "$USER" <$stdin

# Re-run to generate data.toml.
if [ $? -eq 0 ]; then
    "$chezmoi" apply --force

    echo ""
    echo "Bootstrap complete! Restart your terminal to load your new environment!"
fi
