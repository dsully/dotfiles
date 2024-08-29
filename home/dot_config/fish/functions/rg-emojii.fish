function rg-emojii -d "Wrapper around ripgrep to find Emojii in files"

    set regex '\p{RI}\p{RI}|[\\p{Emoji}--\\p{Ascii}](\p{EMod}|\x{FE0F}\x{20E3}?|[\x{E0020}-\x{E007E}]+\x{E007F})?(\x{200D}\p{Emoji}(\p{EMod}|\x{FE0F}\x{20E3}?|[\x{E0020}-\x{E007E}]+\x{E007F})?)*'

    command rg $regex $argv
end
