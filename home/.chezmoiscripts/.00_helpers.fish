#!/usr/bin/env fish

set black (tput setaf 0)
set red (tput setaf 1)
set red_bg (tput setab 1)
set green (tput setaf 2)
set orange (tput setaf 3)
set orange_bg (tput setab 3)
set blue (tput setaf 4)
set cyan (tput setaf 6)
set white (tput setaf 7)
set normal (tput sgr0) # Reset / No Color
set bold (tput bold)

set -gx DEBIAN_FRONTEND noninteractive

if not set -q CHEZMOI_OS
    set CHEZMOI_OS (string lower (uname -s))
end

if not set -q CHEZMOI_ARCH
    set CHEZMOI_ARCH (uname -m)
end

function ask_sudo
    if command sudo -vn &>/dev/null
        # Keep-alive: update existing sudo time stamp if set, otherwise do nothing.
        command sudo -v
    else
        set tid (command grep -c pam_tid /etc/pam.d/sudo)
        tput civis

        if is_macos; and test $tid -eq 1
            info "Use TouchID to authenticate for setup."
        else
            info "Please enter your password for setup: "
        end

        command sudo -v --prompt=""
        tput cnorm
    end
end

function quit_app -a app
    command osascript -e "tell application '$app' to quit" >/dev/null 2>&1
end

# OS check functions
function is_macos
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
    if not is_macos
        error "Unexpected OS ($CHEZMOI_OS), expected macOS!"
        exit 1
    end

    return 0
end

function ensure_linux
    if not is_linux
        error "Unexpected OS ($CHEZMOI_OS), expected Linux!"
        exit 1
    end
end

# Ensure Homebrew
function ensure_homebrew
    if not has_brew
        error "Can't find Homebrew in the PATH."
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
            warn "Homebrew not found!"
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

    set -f char "$cyan─"
    set -f delim (string repeat --no-newline -n $str_len $char)

    echo $delim
    echo "$char $white$message $char"
    echo $delim
end

function sub_task -a message char -d "Print a sub-task header."

    if test -z $char
        set -f char "▶"
    end

    echo "$green  $char $bold$white$message$normal"
end

function error -a msg
    echo $red ✖ $red_bg $bold $white " ERROR " $normal $msg
end

function info -a msg
    echo $cyan ○ $white $msg $normal
end

function prompt -a msg
    echo $blue ▶ $bold $white $msg $normal
end

function start -a msg
    echo $green ▶ $bold $white $msg $normal
end

function success -a msg
    echo $green ✔ $bold $white $msg $normal
end

function warn -a msg
    echo $orange ◆ $bold $orange_bg $black " WARNING " $normal $msg
end

function await -a message success -d "Await last background job with a spinner."
    count (jobs) >/dev/null
    or return 1

    set message "$bold$white$message$normal"

    set spinners "$await_spinners"
    set interval "$await_interval"
    set indent "$await_indent"

    if test -z "$spinners"
        set spinners ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏
    end

    if test -z "$interval"
        set interval 0.04
    end

    # -g so __await_cleanup can see these variables.
    if test -z "$indent"
        set indent ""
    end

    if test -z "$success"
        set success ✔
    end

    set -g complete "$indent$green$success $message"

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
            printf "\r$indent$blue$spinner $message"
            sleep $interval
        end
    end

    functions -e __on_exit
    __await_cleanup
end
