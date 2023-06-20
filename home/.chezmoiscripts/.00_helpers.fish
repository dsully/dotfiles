#!/usr/bin/env fish

# Nord colors
set nord_black "#2e3440"
set nord_white "#eceff4"
set nord_cyan "#8fbcbb"
set nord_cyan_bright "#88c0d0"
set nord_blue "#81a1c1"
set nord_blue_bright "#5e81ac"
set nord_red "#bf616a"
set nord_orange "#d08770"
set nord_yellow "#ebcb8b"
set nord_green "#a3be8c"
set nord_purple "#b48ead"

set red '\e[0;31m'
set green '\e[0;32m'
set orange '\e[0;33m'
set blue '\e[0;34m'
set purple '\e[0;35m'
set cyan '\e[0;36m'
set white '\e[0;37m'
set normal '\e[0m' # Reset / No Color

set -gx DEBIAN_FRONTEND noninteractive

# Ask sudo
function ask_sudo
    glog info "Running this script would need 'sudo' permission."
    sudo -v
end

# OS check functions
function is_darwin
    test $CHEZMOI_OS = darwin
end

function is_linux
    test $CHEZMOI_OS = linux
end

function is_arm64
    test $CHEZMOI_ARCH = arm64
end

# Machine check functions
function is_headless_machine
    test (chezmoi execute-template '{{ get .flags "headless" }}') = true
end

function is_personal_machine
    test (chezmoi execute-template '{{ get .flags "personal" }}') = true
end

function is_work_machine
    test (chezmoi execute-template '{{ get .flags "work" }}') = true
end

# Ensure OS
function ensure_darwin
    if not is_darwin
        glog error "Unexpected OS ($CHEZMOI_OS), expected macOS!"
        exit 1
    end
end

function ensure_linux
    if not is_linux
        glog error "Unexpected OS ($CHEZMOI_OS), expected Linux!"
        exit 1
    end
end

# Ensure Homebrew
function ensure_homebrew
    if not has_brew
        glog error "Can't find Homebrew in the PATH."
        exit 1
    end
end

# Check for Homebrew
function has_brew
    if test -n $HOMEBREW_PREFIX
        set -gx BREW "$HOMEBREW_PREFIX/bin/brew"
    else
        if test -x /opt/homebrew/bin/brew
            set BREW /opt/homebrew/bin/brew
        else if test -x /usr/local/bin/brew
            set BREW /usr/local/bin/brew
        else if test -x /home/linuxbrew/.linuxbrew/brew
            set BREW /home/linuxbrew/.linuxbrew/brew
        else
            glog warn "Homebrew not found!"
            return 1
        end

        eval $($BREW shellenv)
    end

    set -x BREW $BREW

    return 0
end

# Task functions
function TASK
    set str $argv[1]
    set str_len (math "4 + (string length $str)")
    set char $argv[2]

    echo ""
    printf '%*s' $str_len | tr ' ' $char
    echo $char $str $char
    printf '%*s' $str_len | tr ' ' $char
    echo ""
end

function SUB_TASK
    set str $argv[1]
    set char $argv[2]

    echo ""
    echo $char
    echo $str
    echo $char
    echo ""
end

function glog
    set TYPE $argv[1]
    set MSG $argv[2]

    if type -q gum
        switch "$TYPE"
            case error
                echo (gum style --foreground="$nord_red" "✖") (gum style --bold --background="$nord_red" --foreground="$nord_white" " ERROR ")
            case info
                echo (gum style --foreground="$nord_cyan" "○") (gum style --faint --foreground="$nord_white" "$MSG")
            case prompt
                echo (gum style --foreground="$nord_blue" "▶") (gum style --bold "$MSG")
            case start
                echo (gum style --foreground="$nord_green" "▶") (gum style --bold "$MSG")
            case success
                echo (gum style --foreground="$nord_green" "✔") (gum style --bold "$MSG")
            case warn
                echo (gum style --foreground="$nord_yellow" "◆") (gum style --bold --background="$nord_yellow" --foreground="$nord_black" " WARNING ")
            case '*'
                echo (gum style --foreground="$nord_green" "▶") (gum style --bold "$TYPE")
        end
    else
        switch "$TYPE"
            case error
                printf "$red""[ERROR] $normal$MSG\n"
            case info
                printf "$cyan""[INFO] $normal$MSG\n"
            case prompt
                printf "$blue""PROMPT: $normal$MSG\n"
            case start
                printf "$green""[START] $normal$MSG\n"
            case success
                printf "$green""[SUCCESS] $normal$MSG\n"
            case warn
                printf "$orange""[WARNING] $normal$MSG\n"
            case '*'
                echo $MSG
        end
    end
end
