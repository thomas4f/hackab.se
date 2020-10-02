#!/bin/bash

# Used to generate a capture for the "MISHAP" flag
# Populate the FLAG variable with the MISHAP flag, obviously ...

FLAG=""

timeout 2 tcpdump -q -i lo port 443 -s 65535 -w /tmp/HABLegacySvc.pcap 2>/dev/null &
PID=$!
sleep 1

curl -k --ciphers AES128-SHA https://www.hackab.se:443/administration --data "username=admin&password=${FLAG}" -s -o /dev/null
wait $PID

exit 0
