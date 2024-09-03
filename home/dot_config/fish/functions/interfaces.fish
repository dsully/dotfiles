function macos_interfaces
    networksetup -listallhardwareports | awk '
    /Hardware Port:/ {
        port = $3;
        for (i=4; i<=NF; i++) port = port " " $i;
        gsub(/:$/, "", port);
    }
    /Device:/ {
        print $2 ":" port;
    }'
end

function linux_interfaces
    for device in /sys/class/net/*
        set -l device_name (basename $device)
        if test -d "$device/wireless"
            echo "$device_name:Wi-Fi"
        else if test -f "$device/type"
            set -l type (cat "$device/type")
            if test "$type" = 1
                echo "$device_name:Ethernet"
            else if test "$type" = 772
                echo "$device_name:Loopback"
            end
        end
    end
end

function get_ip_address
    set -l device $argv[1]

    if test "$OS" = Darwin
        ipconfig getifaddr $device 2>/dev/null
    else if test "$OS" = Linux
        ip -4 addr show $device | awk '/inet / {print $2}' | cut -d/ -f1
    end
end

function interfaces
    if test "$OS" = Darwin
        set net_interfaces (macos_interfaces)
    else if test "$OS" = Linux
        set net_interfaces (linux_interfaces)
    else
        echo "Unsupported operating system: $OS"
        return 1
    end

    for interface in $net_interfaces
        set -l device (string split ":" $interface)[1]
        set -l interface_type (string split ":" $interface)[2]
        set -l ip_address (get_ip_address $device)

        if test -n "$ip_address"
            echo "$device: $ip_address - $interface_type"
        end
    end
end
