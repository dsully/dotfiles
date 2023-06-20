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

if not set -q CHEZMOI_OS
    set CHEZMOI_OS (string lower (uname -s))
end

if not set -q CHEZMOI_ARCH
    set CHEZMOI_ARCH (uname -m)
end

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

    return 0
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
    if set -q HOMEBREW_PREFIX
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
function task -a message -d "Print a task header."

    # Compute the proper length of Unicode strings.
    set -f str_len (echo -n $message | wc -m)
    set -f delta (math (echo -n $message | wc -c) - $str_len)
    set -f str_len (math $str_len + (math ceil $delta / 2) + 4)

    set -f char (gum style --foreground=$nord_cyan_bright "─")
    set -f delim (string repeat --no-newline -n $str_len $char)

    echo $delim
    echo $char (gum style --foreground=$nord_white $message) $char
    echo $delim
end

function sub_task -a message char -d "Print a sub-task header."

    if test -z $char
        set -f char "▶"
    end

    echo (gum style --foreground=$nord_green "  $char") (gum style --bold $message)
end

function glog -a TYPE MSG

    if type -q gum
        switch "$TYPE"
            case error
                echo (gum style --foreground="$nord_red" "✖") (gum style --bold --background="$nord_red" --foreground="$nord_white" " ERROR ") $MSG
            case info
                echo (gum style --foreground="$nord_cyan" "○") (gum style --faint --foreground="$nord_white" "$MSG")
            case prompt
                echo (gum style --foreground="$nord_blue" "▶") (gum style --bold "$MSG")
            case start
                echo (gum style --foreground="$nord_green" "▶") (gum style --bold "$MSG")
            case success
                echo (gum style --foreground="$nord_green" "✔") (gum style --bold "$MSG")
            case warn
                echo (gum style --foreground="$nord_yellow" "◆") (gum style --bold --background="$nord_yellow" --foreground="$nord_black" " WARNING ") $MSG
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

function await -a message success -d "Await last background job with a spinner."
    count (jobs) >/dev/null
    or return 1

    set message (gum style --bold "$message")

    set spinners "$await_spinners"
    set interval "$await_interval"
    set indent "$await_indent"

    if test -z "$spinners"
        set spinners (gum style --foreground="$nord_blue" ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
    end

    if test -z "$interval"
        set interval 0.04
    end

    # -g so __await_cleanup can see these variables.
    if test -z "$indent"
        set indent ""
    end

    if test -z "$success"
        set success "✔"
    end

    set -g complete "$indent"(gum style --foreground="$nord_green" "$success") $message

    function __await_cleanup
        # Print the message with a check mark at the beginning of the line.
        printf \r
        echo $complete
        set -e complete

        tput cnorm
        stty echo
        trap INT
    end

    function __await_kill_children
        for x in (jobs -p | grep -v 'Process')
            kill $x
        end
    end

    function __on_exit --on-job-exit %self
        __await_cleanup
        __await_kill_children
        functions -e __on_exit
    end

    # Hide the cursor.
    tput civis
    stty -echo

    jobs -l | read -l job tail

    trap __await_cleanup INT

    while contains $job (jobs | cut -d\t -f1)

        for spinner in $spinners
            printf "\r$indent$spinner $message"
            sleep $interval
        end
    end

    functions -e __on_exit
    __await_cleanup
end
