#!'bin/bash

lsusb -v -d 0403: 2> /dev/null | \grep -E "iProduct|iSerial" | awk '{$1=$1;print}' > lsusb.ftdi
python3 ftdi.py

# End
