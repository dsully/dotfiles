function ringtone -d "Create a ringtone from an audio file."

    # https://apple.stackexchange.com/questions/431183/how-do-i-set-an-m4r-file-ringtone-i-airdropped-to-my-iphone-13
    set input $argv[1]
    set output (string trim -r -c '.' $input)

    command ffmpeg -i $input -ac 1 -b:a 128k -f mp4 -c:a aac -t 29.99 -y $output.m4r
end
