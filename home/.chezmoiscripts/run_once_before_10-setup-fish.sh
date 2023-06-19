#!/usr/bin/env bash

set -eufo pipefail

if command -v fish &>/dev/null; then

    echo -e "\0033[0;32m>>>>> Begin Setting Up Fish Shell <<<<<\033[0m"

    # Set fish as default shell
    if [ $SHELL != $(which fish) ]; then
      echo "Changing default shell to fish"
      chsh -s $(which fish)
    fi

    echo -e "\0033[0;32m>>>>> Finish Setting Up Fish Shell <<<<<\033[0m"
fi
