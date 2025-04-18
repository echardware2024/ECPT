#!/bin/bash

# set baud from 2 to 1
picocom -qrX -b 230400 --flow x --send-cmd ascii-xfr /dev/ttyUSB0
echo "baud 1" | picocom -qrix 100 /dev/ttyUSB0

# End
