#!/usr/bin/env sh

OS=$(uname)

if [ "$OS" = "Darwin" ]; then

    CHASSIS=$(/usr/sbin/system_profiler -json SPHardwareDataType | grep MacBook)

    if [ "$CHASSIS" ]; then
        CHASSIS=laptop
    else
        CHASSIS=desktop
    fi

    HOSTNAME=$(scutil --get ComputerName | cut -d'.' -f1)

    echo "{ \"Chassis\": \"$CHASSIS\", \"Hostname\": \"$HOSTNAME\"}"

else
    if [ "$(lsb_release -is)" = "CentOS" ]; then
        CHASSIS=$(hostnamectl | grep Chassis | awk '{print $2}')
        HOSTNAME=$(hostnamectl | grep StaticHostname | awk '{print $2}')

        echo "{ \"Chassis\": \"$CHASSIS\", \"Hostname\": \"$HOSTNAME\"}"
    else
        hostnamectl --json=short
    fi
fi
