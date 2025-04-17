#!/bin/bash

command="stats"
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
  cat $foo | sed "s/VAL,  V_P3V3,   I_P3V3,   TEMP,      T_SAK,    W_P3V3/VAL,     V_3V3,    I_3V3,     TEMP,    T_SAK,    P_3V3/g" > $bar
  python3 tpiv.py
else
  echo "Failed (/dev/ttyUSB0 is not connected)"
  echo "Failed (/dev/ttyUSB0 is not connected)" > $foo
  echo "Failed (/dev/ttyUSB0 is not connected)" > $bar
fi

# EOF

# cd ~/prodtest/bin/ && source stats.sh
# cat ./foo-stats && cat ./bar-stats
