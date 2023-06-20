#!/usr/bin/env bash

# -e: exit on error
# -u: exit on unset variables
set -eufo pipefail

# Nord colors
nord_black="#2e3440"
nord_white="#eceff4"
nord_cyan="#8fbcbb"
nord_cyan_bright="#88c0d0"
nord_blue="#81a1c1"
nord_blue_bright="#5e81ac"
nord_red="#bf616a"
nord_orange="#d08770"
nord_yellow="#ebcb8b"
nord_green="#a3be8c"
nord_purple="#b48ead"

declare -r red='\e[0;31m'
declare -r green='\e[0;32m'
declare -r orange='\e[0;33m'
declare -r blue='\e[0;34m'
declare -r purple='\e[0;35m'
declare -r cyan='\e[0;36m'
declare -r white='\e[0;37m'
declare -r normal='\e[0m' # Reset / No Color

command_exists() {
    type "${1}" >/dev/null 2>&1
}

is_darwin() {
    [[ $CHEZMOI_OS == darwin ]]
}

ensure_homebrew() {
    if ! has_brew; then
        glog "error" "Can't find Homebrew in the PATH."
        exit 1
    fi
}

has_brew() {
    if [ "$HOMEBREW_PREFIX" != "" ]; then
        BREW="$HOMEBREW_PREFIX/bin/brew"
    else
        if [[ -x /opt/homebrew/bin/brew ]]; then
            BREW=/opt/homebrew/bin/brew
        elif [[ -x /usr/local/bin/brew ]]; then
            BREW=/usr/local/bin/brew
        elif [[ -x /home/linuxbrew/.linuxbrew/brew ]]; then
            BREW=/home/linuxbrew/.linuxbrew/brew
        else
            glog "warn" "Homebrew not found!"
            return 1
        fi

        eval "$("$BREW" shellenv)"
    fi

    export BREW=$BREW

    return 0
}

glog() {
    TYPE="$1"
    MSG="$2"

    if [ -x "$(command -v gum)" ]; then

        case "$TYPE" in
            'error')
                gum_style="$(gum style --foreground="$nord_red" "✖") $(gum style --bold --background="$nord_red" --foreground="$nord_white" " ERROR ")"
                ;;
            'info')
                gum_style="$(gum style --foreground="$nord_cyan" "○") $(gum style --faint --foreground="$nord_white" "$MSG")"
                ;;
            'prompt')
                gum_style="$(gum style --foreground="$nord_blue" "▶") $(gum style --bold "$MSG")"
                ;;
            'start')
                gum_style="$(gum style --foreground="$nord_green" "▶") $(gum style --bold "$MSG")"
                ;;
            'success')
                gum_style="$(gum style --foreground="$nord_green" "✔") $(gum style --bold "$MSG")"
                ;;
            'warn')
                gum_style="$(gum style --foreground="$nord_yellow" "◆") $(gum style --bold --background="$nord_yellow" --foreground="$nord_black" " WARNING ")"
                ;;
            *)
                gum_style="$(gum style --foreground="$nord_green" "▶") $(gum style --bold "$TYPE")"
                ;;
        esac

        gum style "$gum_style"

    else
        case "$TYPE" in
            'error')
                printf "${red}[ERROR] ${normal}$MSG\n"
                ;;
            'info')
                printf "${cyan}[INFO] ${normal}$MSG\n"
                ;;
            'prompt')
                printf "${blue}PROMPT: ${normal}$MSG\n"
                ;;
            'start')
                printf "${green}[START] ${normal}$MSG\n"
                ;;
            'success')
                printf "${green}[SUCCESS] ${normal}$MSG\n"
                ;;
            'warn')
                printf "${orange}[WARNING] ${normal}$MSG\n"
                ;;
            *)
                echo "$MSG"
                ;;
        esac
    fi
}
