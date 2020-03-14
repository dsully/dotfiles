# Open new iTerm tabs from the command line.
#
# USAGE
#
#   tab                     Opens the current directory in a new tab
#   tab [path]              Open PATH in a new tab
#   tab [cmd]               Open a new tab and execute CMD
#   tab [path] [cmd] ...    You can prolly guess
#
# If you use iTerm and your default session profile isn't "Default Session",
# override it in your `config.fish` or `omf/init.fish`
#
#     set -g tab_iterm_profile "MyProfile"

function tab -d 'Open the current directory (or any other directory) in a new tab'
  set -l cdto $PWD
  set -l cmd

  if test (count $argv) -gt 0
    switch $argv[1]
      case "-h" "--help"
        echo "\
Open new terminal tabs from the command line

Usage:
  tab [dir] [command]

Options:
  -h --help         Display this help message.

Arguments:
  dir               Working directory for the new tab [default: pwd]
  command           Command to run in the new tab
"
      return
    end
  end

  if test (count $argv) -gt 0
    if test -d $argv[1]
      pushd . >/dev/null
      cd $argv[1]
      set cdto $PWD
      set -e argv[1]
      popd >/dev/null
    end
  end

  if test (count $argv) -gt 0
    set cmd "; $argv"
  end

  set -l profile "default profile"

  osascript 2>/dev/null -e "
    tell application \"iTerm\"
      tell current window
        set newTab to (create tab with $profile)
        tell current session of newTab
          write text \"cd \\\"$cdto\\\"$cmd\"
        end tell
      end tell
    end tell
  "
end
