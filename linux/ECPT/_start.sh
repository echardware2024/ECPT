#!/bin/bash

# get two lines of usb info then analyze
lsusb -v -d 0403: 2> /dev/null | \grep -E "iProduct|iSerial" | awk '{$1=$1;print}' > ./lsusb.ftdi
python3 ftdi2cfg.py  # creates cfg.edit with usb info and today's date

# send over serial
picocom -qrX -b 115200 --flow x --send-cmd ascii-xfr /dev/ttyUSB0  # setup
cat ./cfg.edit | picocom -qrix 100 /dev/ttyUSB0  # send

printf "\n\e[1;35mCycle power to load new cfg-edit parameters\e[0m\n\n"

# End

# debug, skip to end of current attempt:
# echo "/" | picocom -qrix 100 /dev/ttyUSB0

# test this script:
# cd ~/ECPT/linux/ && source ./_start.sh
