#!/usr/bin/env bash

# vim:ft=bash
# https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/
#
# -e: exit on error
# -u: exit on unset variables
set -eu

AGE_BIN=age
ARCHITECTURE=""
OS=""

CHEZMOI_SRC="${HOME}/.local/share/chezmoi"
CHEZMOI_DST="${HOME}/.config/chezmoi"
CHEZMOI_KEY="${CHEZMOI_DST}/key.txt"

case $(uname -m) in
    i386 | i686) ARCHITECTURE="386" ;;
    x86_64) ARCHITECTURE="amd64" ;;
    arm64) ARCHITECTURE="arm64" ;;
    *)
        echo "No age crypto support for $(uname -m)"
        exit 0
        ;;
esac

case $(uname -s) in
    Darwin) OS="darwin" ;;
    Linux) OS="linux" ;;
    *)
        echo "No age crypto support for $(uname -s)"
        exit 0
        ;;
esac

AGE_DOWNLOAD_URL="https://github.com/FiloSottile/age/releases/download/v1.1.1/age-v1.1.1-${OS}-${ARCHITECTURE}.tar.gz"
AGE_TMP_DIR="/tmp/age"

if ! command -v "$AGE_BIN" &>/dev/null; then
    rm -rf "$AGE_TMP_DIR"
    mkdir -p "$AGE_TMP_DIR"
    curl -sL "$AGE_DOWNLOAD_URL" | tar -xz --strip-components 1 -C "$AGE_TMP_DIR"
    AGE_BIN="$AGE_TMP_DIR/age"
    chmod +x "$AGE_BIN"
fi

if [ ! -f "$CHEZMOI_KEY" ]; then
    mkdir -p "$CHEZMOI_DST"
    "$AGE_BIN" --decrypt --output "$CHEZMOI_KEY" "${CHEZMOI_SRC}/.data/key.txt.age"
    chmod 600 "$CHEZMOI_KEY"
fi

rm -rf "$AGE_TMP_DIR"
