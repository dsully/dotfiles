# colors documentation can be found at
# http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#256-colors
function man -d "Run man with added colors" --wraps=man

    set -l end (printf "\e[0m")

    set -lx LESS_TERMCAP_mb (set_color bf616a) #bf616a
    set -lx LESS_TERMCAP_md (set_color -o 81a1c1) #81a1c1
    set -lx LESS_TERMCAP_me $end
    set -lx LESS_TERMCAP_so (set_color d8dee9) #d8dee9
    set -lx LESS_TERMCAP_se $end
    set -lx LESS_TERMCAP_us (set_color -u 8fbcbb) #8fbcbb
    set -lx LESS_TERMCAP_ue $end

    command man $argv
end
