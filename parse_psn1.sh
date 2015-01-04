#!/bin/bash

# parse /proc/net/dev


if [ $# -lt 1 ]; then
  echo "Usage: script file <interface>\n"
  exit 0
fi
_infile=$1
_interface='eth0'
if [ $# -gt 1 ]; then
    _interface=$2;
fi

# produces bytes in
 awk "/^ *${_interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { sub(/^.*:/, "") ; print $1 } else { print $2 } }' $_infile

# bytes out
#awk "/^ *${_interface}:/"' { if ($1 ~ /.*:[0-9][0-9]* /) { print $9 } else { print $10 } }' $_infile
