#!/bin/bash

# Ok, this isn't 100% realistic, but need this in order not to distract people.

PS=$(/bin/ps aux)
echo "${PS}" | /bin/sed -e 's/\ ;\ sleep 15//g' -e 's/\/bin\/sh\ //g' | egrep -v "(admin|sleep 15|/usr/local/bin/nginx|ncat|]$)"