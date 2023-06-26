#!/usr/bin/env sh

if [ "$(lsb_release -is)" = "CentOS" ]; then
    CHASSIS=$(hostnamectl | grep Chassis | awk '{print $2}')

    echo "{ \"Chassis\": \"$CHASSIS\" }"
else
    hostnamectl --json=short
fi
