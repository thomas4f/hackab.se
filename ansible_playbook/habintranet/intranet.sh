#!/bin/sh

while true; do
  /usr/bin/ncat -l 127.0.0.1 -p 31337 -c '/bin/cat /opt/habintranet/intranet.txt'
done
