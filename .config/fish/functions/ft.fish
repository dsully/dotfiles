# Open new Finder tabs from the command line.
#
# USAGE
#
#   ft                     Opens the current directory in a new tab
#   ft [path]              Open PATH in a new tab
#

function ft -d 'Open the current directory (or any other directory) in a new Finder tab'

  if test (count $argv) -gt 0
    set open "$PWD/$argv"
  else
    set open $PWD
  end

  command osascript 2>/dev/null -e "
    tell application \"Finder\"
      activate
      set t to target of Finder window 1
      set toolbar visible of window 1 to true
    end tell
    tell application \"System Events\"
        keystroke \"t\" using command down
    end tell
    tell application \"Finder\"
        set target of Finder window 1 to POSIX file \"$open\"
    end tell
  " 1> /dev/null
end
