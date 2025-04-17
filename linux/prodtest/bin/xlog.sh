#!/bin/bash

command="xlog"
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
  cat $foo | \grep -i -E 'edgecortix|variant|pass|fail|fault|error' | awk '{$1=$1;print}' > $bar  # includes failed and fail, errors and error
  temp=$(cat $bar | \grep -i -o -E 'bist.*pass|bist.*fail|sakura.*pass|sakura.*fail' | sed "s/BIST.*PASS/BP/g" | sed "s/BIST.*FAIL/BF/g" | sed "s/sakuraStart.*PASS/SSP/g")  # abbreviate pass and fail
  echo $temp
else
  echo "Failed (/dev/ttyUSB0 is not connected)"
  echo "Failed (/dev/ttyUSB0 is not connected)" > $foo
  echo "Failed (/dev/ttyUSB0 is not connected)" > $bar
fi

# EOF

# cd ~/prodtest/bin/ && source xlog.sh
# cat ./foo-xlog
# cat ./bar-xlog
