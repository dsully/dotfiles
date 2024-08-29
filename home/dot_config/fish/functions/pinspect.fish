function pinspect --description 'Print the contents of the PATH variable, one entry per line'
    echo "$PATH" | tr ":" "\n"
end
