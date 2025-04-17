#!/bin/bash

command="info"
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
  cat $foo | \grep -i -E "variant|revision" | awk '{$1=$1;print}' > $bar  # filtered version with formatting
  cat $bar | \grep -i -o -E "primary|secondary" || echo "(Unknown BMC Image)"  # print one of three outcomes
else
  echo "Failed (/dev/ttyUSB0 is not connected)"
  echo "Failed (/dev/ttyUSB0 is not connected) abcde-EC-xyz" > $foo
  echo "Failed (/dev/ttyUSB0 is not connected) abcde-EC-xyz" > $bar
fi

# EOF

# cd ~/prodtest/bin/ && source info.sh
