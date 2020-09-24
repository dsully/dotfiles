#!/bin/bash

# /Applications/GlobalProtect.app/Contents/Resources/Scripts
# Updates DNS records for GlobalProtect VPN

if [[ -f /tmp/GlobalProtect_Debug ]]; then
  set -xv # Enable Debugging
  exec 3>&1 4>&2
  trap 'exec 2>&4 1>&3' 0 1 2 3
  exec 1>>/tmp/GlobalProtect_DNS.log 2>&1
fi

# Check script paramater passed from GlobalProtect
if [[ $1 == "pre-vpn-disconnect" ]]; then
  # Set connection state
  Event="Disconnected"
elif [[ $1 == "post-vpn-connect" ]]; then
  # Set connection state
  Event="Connected"
fi

# Check if we can resolve tools server
if host -W 5 lva1-wintools02.linkedin.biz ; then
    echo "Resolved lva1-wintools02.linkedin.biz"
else
    echo "Unable to resolve lva1-wintools02.linkedin.biz, exiting..."
    exit 1
fi

# Set AD domain
domain="linkedin.biz"

# Set hostname
HOSTNAME=$(cat /private/var/client/data/HOSTNAME)

# Set System Serial Number
SSN=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')

# set webhook URL for task server
WEBHOOK_URL="http://lva1-wintools02.linkedin.biz:5001/webhook/v1?key=24ffc5be-7dd8-479f-898e-27169bf23e7f"

# get IPv4 address
ipv4addr=$(ifconfig gpd0 | \
      awk '/inet/{print $2}' | \
      grep -v "::")

# get IPv4 address
ipv4addr=$(curl \
            -s \
            -o /dev/null \
            -w "%{local_ip}" \
            --connect-timeout 5 \
            --max-time 5 \
            --retry 10 \
            --retry-delay 0 \
            --retry-max-time 5 \
            https://cinco.linkedin.biz
        )

# get current UNIX time (epoch)
EpochTime=$(date +'%s')

# Get nameservers assigned to client
NameSrv1=$(/usr/sbin/scutil --dns | awk '/nameserver\[0\]/{print $3}' | head -1)
NameSrv2=$(/usr/sbin/scutil --dns | awk '/nameserver\[1\]/{print $3}' | head -1)

# Format request data into JSON
JSON_DATA="{\"FQDN\": \"${HOSTNAME}.${domain}\", \"Ipv4Addr\": \"${ipv4addr}\", \"NameSrv1\": \"${NameSrv1}\", \"NameSrv2\": \"${NameSrv2}\", \"Event\": \"${Event}\", \"TimeStamp\": \"${EpochTime}\", \"SerialNumber\": \"${SSN}\"}"

# GET IP of hostname in DNS
DNS_IP_CHECK=$(host $HOSTNAME.$domain | awk {'print $NF'})

# Construct PTR from IP
PTR=$(echo $ipv4addr | \
  awk 'BEGIN{FS="."}{print $4"."$3"."$2"."$1".in-addr.arpa."}')

# GET PTR in DNS
PTR_CHECK=$(host ${ipv4addr} | awk {'print $1'})

# Verify forward and reverse lookups in DNS and log
if [[ "$DNS_IP_CHECK" == "$ipv4addr" && "$PTR_CHECK." == "$PTR" && "$Event" == "Connected" ]]; then
  logger -is -t com.globalprotect.dns -p info "DNS Records Already Up-To-Date"
  exit 0
  else
  logger -is -t com.globalprotect.dns -p info "Updating DNS Record: $JSON_DATA"
fi

# Check and wait for tools server to be available
c=0
while ! nc -z -G 1 "lva1-wintools02.linkedin.biz" 5001  > /dev/null ||
      ! curl -s http://lva1-wintools02.linkedin.biz:5001 > /dev/null; do
  sleep 1
  ((c++)) && ((c==60)) && c=0 && exit 1
done

# Post to task server
curl --connect-timeout 5 \
    --max-time 10 \
    --retry 5 \
    --retry-delay 0 \
    --retry-max-time 40 \
    -H "Content-Type: application/json" \
    -d "${JSON_DATA}" \
    "${WEBHOOK_URL}"

exit 0
