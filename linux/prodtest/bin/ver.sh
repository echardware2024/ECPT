#!/bin/bash

command="ver"
foo="./foo-$command"
bar="./bar-$command"
timeout="500"

# make sure files are empty, start with timestamp
printf "%s\n" "$(date)" > $foo
printf "%s\n" "$(date)" > $bar

# set up picocom
if [ -e /dev/ttyUSB0 ]; then
  picocom -qrX -b 115200 --flow x --send-cmd ascii-xfr /dev/ttyUSB0
  echo $command | picocom -qrix $timeout /dev/ttyUSB0 > $foo
  rev=$(cat $foo | \grep -o "Revision.*," || echo "(Unknown)")  # store one of two outcomes
  echo $rev | sed "s/,//g"  # remove comma
else
  echo "Failed (/dev/ttyUSB0 is not connected)"
  echo "Failed (/dev/ttyUSB0 is not connected)" > $foo
  echo "Failed (/dev/ttyUSB0 is not connected)" > $bar
fi

# EOF

# cd ~/prodtest/bin/ && source ver.sh
