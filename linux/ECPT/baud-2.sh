#!/bin/bash

# set baud from 1 to 2
picocom -qrX -b 115200 --flow x --send-cmd ascii-xfr /dev/ttyUSB0
echo "baud 2" | picocom -qrix 100 /dev/ttyUSB0

# End
