#!/bin/bash

command="cfge"  # generic command
foo="./foo-$command"
bar="./bar-$command"
timeout="500"
command="cfg"  # BMC command

# make sure files are empty, start with timestamp
printf "%s\n" "$(date)" > $foo
printf "%s\n" "$(date)" > $bar

# set up picocom
if [ -e /dev/ttyUSB0 ]; then
  picocom -qrX -b 115200 --flow x --send-cmd ascii-xfr /dev/ttyUSB0
  echo $command | picocom -qrix $timeout /dev/ttyUSB0 > $foo
  python3 cfge.py > $bar  # reconstitute original string
  rev=$(cat $foo | \grep -o -P ".*\K\(rev.*\)" || echo "(Unknown)")  # store one of two outcomes
  echo $rev
else
  echo "Failed (/dev/ttyUSB0 is not connected)"
  echo "Failed (/dev/ttyUSB0 is not connected)" > $foo
  echo "Failed (/dev/ttyUSB0 is not connected)" > $bar
fi

# EOF

# cd ~/prodtest/bin/ && source cfge.sh
# cat ./foo-cfge
# python3 cfge.py
# cat ./bar-cfge
