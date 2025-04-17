#!/bin/bash

# determine wait timer
if [ $# == 1 ]; then  # one arg was passed
  n="$1"  # set to arg
  help=""
else
  n="1"  # default is 1 iteration
  help=" Type 'bist n' to run n interations."
fi
delay="5000"  # wait for more serial data, default is five seconds

function purple () {
  printf "\e[1;35m%b\e[0m" "$1"
}
cyan="\e[1;36m"
none="\e[0m"

# initial warning
echo
purple "This process may take a while. Do not access the serial port until it completes.$help\n"
echo

# set up picocom
picocom -qrX -b 115200 --flow x --send-cmd ascii-xfr /dev/ttyUSB0  # q = quiet, r = no-reset, X = exit immediately 

# send bist command, wait up to [delay] seconds for more data
printf "Delay = $delay ms, n = $n\n"
start=$(date +%s%3N)
echo "bist all errstop -n $n" | picocom -qrix $delay /dev/ttyUSB0  # q = quiet, r = no-reset, i = no-init, x = exit after [delay]
end=$(date +%s%3N)
elapsedms=$((end-start-delay))  # subtract the final wait timer since it doesn't really count
elapsed=$(echo "$elapsedms/1000" | bc -l)
rate=$(echo "$elapsed/$n" | bc -l)

# hopefully it finished!
echo
printf "%.1f seconds / %d = $cyan%.1f$none seconds per iteration\n" $elapsed $n $rate
purple "Done. -HJS\n"
echo

# play sound
aplay ~/prodtest/bin/440.wav --quiet

# End

# bist [a|b|ab|a0|a1|b0|b1|all] [mode] [test] [errstop] [-n 999] [-a 0x123]
# 
# Run DDR BIST now:
#     Use A, B, or AB to test both ddr0 and ddr1.
#     Use a0, a1, b0, or b1 to test ddr0 on A, ddr1 on A, etc.
#     Use ALL to test A0, A1, B0, B1.
# 
#     [mode] is ctlr or pi.
# 
#     [test] is addr or data.
# 
#     [errstop] stops iterating when an error is encountered; otherwise BIST runs
#     all n iterations.
# 
#     [-n 999] specifies the iteration count. The default is 1. The maximum value
#     is 0xffffffff.
# 
#     [-a 0xNNN] specifies the address space used for the test; a missing
#     value or a value of 0 selects the default address space.
