#!/bin/bash

foo="./foo-ftdi"
bar="./bar-ftdi"

# make sure files are empty, start with timestamp
printf "%s\n" "$(date)" > $foo
printf "%s\n" "$(date)" > $bar

lsusb -v -d 0403: 2> /dev/null > $foo  # run command, overwrite
cat $foo | \grep -E "idVendor|idProduct|iManufacturer|iProduct|iSerial" | awk '{$1=$1;print}' > $bar  # filtered version with formatting
cat $bar | \grep -o -P "iSerial 3 \K.*" || echo "(Unknown FTDI SN)"  # print serial number, or Unknown

# EOF

# cd ~/prodtest/bin/ && source ftdi.sh
