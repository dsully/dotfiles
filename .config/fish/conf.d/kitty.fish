# Kitty terminal emulator integration.
if status is-interactive
    
    if test $TERM = xterm-kitty
        set -gx fish_term24bit 1
        set -gx KITTY_SHELL_INTEGRATION no-cursor

        alias ssh="kitty +kitten ssh"
    end
end
