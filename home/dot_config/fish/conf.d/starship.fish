# https://github.com/jdxcode/rtx
if status is-interactive; and type -q starship

    source (command starship init fish --print-full-init | psub)
end
