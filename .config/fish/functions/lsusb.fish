function lsusb --wraps=cyme --description 'Use cyme instead of lsusb'

    if type -q cyme
        command cyme $argv
    else
        command lsusb $argv
    end
end
