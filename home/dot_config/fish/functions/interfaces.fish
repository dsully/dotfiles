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
        set -f ipv4 (ipconfig getifaddr $device)
        set -f ipv6 (ifconfig $device | awk '/inet6 / && !/fe80::/ {print $2}')
    else if test "$OS" = Linux
        set -f ipv4 (ip -4 addr show $device | awk '/inet / {print $2}' | cut -d/ -f1)
        set -f ipv6 (ip -6 addr show $device | awk '/inet6 / && !/fe80::/ {print $2}' | cut -d/ -f1)
    end

    echo $ipv4 $ipv6
end

function interfaces
    if test "$OS" = Darwin
        set net_interfaces (macos_interfaces | sort)
    else if test "$OS" = Linux
        set net_interfaces (linux_interfaces | sort)
    else
        echo "Unsupported operating system: $OS"
        return 1
    end

    # Create associative arrays to store interfaces by type
    set -l ethernet_interfaces
    set -l loopback_interfaces
    set -l wifi_interfaces
    set -l other_interfaces

    set -lx blue '\x1B\e[34m'
    set -lx green '\x1B\e[32m'
    set -lx reset '\x1B\e[0m'

    for interface in $net_interfaces
        set -l device (string trim (string split ":" $interface)[1])
        set -l interface_type (string split ":" $interface)[2]

        switch $interface_type
            case "USB 10/100/1G/2.5G LAN"
                set -a ethernet_interfaces $device
            case Ethernet
                set -a ethernet_interfaces $device
            case Loopback
                set -a loopback_interfaces $device
            case Wi-Fi
                set -a wifi_interfaces $device
            case '*'
                set -a other_interfaces $device
        end
    end

    # Sort and print interfaces by type
    function print_interfaces
        set -l type $argv[1]
        set -l interfaces $argv[2..-1]

        if test (count $interfaces) -gt 0
            echo -e $green$type$reset":"

            for device in $interfaces
                echo "    $device"

                set -l addresses (string split " " (get_ip_address $device) | sort)

                if test (count $addresses) -gt 1

                    for ip in $addresses
                        echo -e "        $blue$ip$reset"
                    end
                end
            end

            echo
        end
    end

    print_interfaces Ethernet $ethernet_interfaces
    print_interfaces Loopback $loopback_interfaces
    print_interfaces Wi-Fi $wifi_interfaces
    print_interfaces Other $other_interfaces
end
