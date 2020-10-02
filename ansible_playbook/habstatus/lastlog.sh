#!/bin/bash

# Ok, this isn't 100% realistic, but need this in order not to distract people.

/usr/bin/lastlog | egrep -v "^admin"

exit 0
