#!/bin/sh -e

set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

if [ ! -e /Library/Developer/CommandLineTools/usr/bin/git ]; then

    start "Installing Apple Developer CLI Tools. Press any key when the installation has completed."
    xcode-select --install > /dev/null 2>&1
    read -r "" -sn1
fi

if ! command -v chezmoi > /dev/null; then
    bin_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
    chezmoi="$bin_dir/chezmoi"

    chezmoi_url="https://www.chezmoi.io/get"

    if command -v curl > /dev/null; then
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

# Set the path for everything else.
export PATH=/opt/homebrew/bin:/home/linuxbrew:"$HOME"/.cargo/bin:"$HOME"/.local/bin:"$PATH"

"$chezmoi" init --apply --exclude encrypted "$@" "$USER" < "$stdin"

export NIX_INSTALLER_EXTRA_CONF="trusted-users = @wheel"
export NIX_INSTALLER_FORCE=1
export NIX_INSTALLER_ENABLE_FLAKES=1
export NIX_INSTALLER_NO_CONFIRM=1

# Re-run to generate data.toml.
if [ $? -eq 0 ]; then
    "$chezmoi" apply --force

    echo ""
    echo "Bootstrap complete! Restart your terminal to load your new environment!"
fi
