function lsusb --wraps=cyme --description 'Use cyme instead of lsusb; List system USB buses and devices; a modern cross-platform `lsusb`'

    if command -q cyme
        command cyme $argv
    else
        command lsusb $argv
    end
end
