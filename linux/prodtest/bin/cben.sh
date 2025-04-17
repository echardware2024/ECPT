#!/bin/bash

command="cben"  # simple version of command
foo="./foo-$command"
bar="./bar-$command"
timeout="500"
command="pins \"*EN_PG*\""  # full version of command

# make sure files are empty, start with timestamp
printf "%s\n" "$(date)" > $foo
printf "%s\n" "$(date)" > $bar

# set up picocom
if [ -e /dev/ttyUSB0 ]; then
  picocom -qrX -b 115200 --flow x --send-cmd ascii-xfr /dev/ttyUSB0
  echo $command | picocom -qrix $timeout /dev/ttyUSB0 > $foo
  cat $foo | \grep -E 'AEN|BEN|M2EN' | awk '{$1=$1;print}' > $bar
  temp=$(cat $bar | \grep -i -o -E ' 1 | 0 ' || echo "(Unknown CB Status)")  # removes newlines
  echo $temp
else
  echo "Failed (/dev/ttyUSB0 is not connected)"
  echo "Failed (/dev/ttyUSB0 is not connected)" > $foo
  echo "Failed (/dev/ttyUSB0 is not connected)" > $bar
fi

# EOF
