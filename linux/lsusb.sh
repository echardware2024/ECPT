#!/bin/bash

# get two lines of usb info and analyze
lsusb -v -d 0403: 2> /dev/null | \grep -E "iProduct|iSerial" | awk '{$1=$1;print}' > lsusb.ftdi
python3 ftdi.py

# send over serial
picocom -qrX -b 115200 --flow x --send-cmd ascii-xfr /dev/ttyUSB0
cat ./cfg.edit | picocom -qrix 100 /dev/ttyUSB0

# End
