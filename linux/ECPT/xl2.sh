#!/bin/bash

baud="230400"
# baudx="2"  # not used by picocom
# undo="br2x"  # not used by picocom
folder="hex"  # default, may get overwritten
hexver="S115"  # default, update as needed
stats="Expected integers for S115 -> 12631 201840 198 0x00080000 0x000b146f"  # integers displayed by BMC after xload completes
help="0"  # default, didn't ask for help

if [ $# == 1 ]; then  # one arg was passed
  hexver="$1"  # set to arg, overwrite default version
  if [ "$hexver" == "-d" ]; then  # special case, debug
    folder="hex-debug"
    hexver="xload"
  elif [ "$hexver" == "-L" ]; then  # special case, linux-compiled
    folder="hex-validation"
    hexver="SL"
  elif [ "$hexver" == "-W" ]; then  # special case, windows-compiled
    folder="hex-validation"
    hexver="SW"
  elif [ "$hexver" == "-h" ]; then  # special case, help
    echo "  -d: debug version"
    echo "  -h: this file"
    echo "  -L: secondary Linux validation"
    echo "  -W: secondary Windows validation"
    help="1"
  fi
fi

function red () {
  printf "\e[1;31m%b\e[0m" "$1"
}

function purple () {
  printf "\e[1;35m%b\e[0m" "$1"
}

# only finish script if help was not passed
if [ "$help" == "0" ]; then 
  # initial warning
  echo
  purple "This process may take up to a minute. Do not access the serial port until it completes.\n"
  echo

  # change baud rate, need to rewrite using picocom
  # python3 ~/HJS/statlog/statlog.py S2XX-baud.$baudx | \grep "baud "  # >> /dev/null
  echo "Setting baud rate to 230400"
  source ~/hex-ftdi-cfg/hex/baud-2.sh

  # set up picocom
  if [ -e /dev/ttyUSB0 ]; then
    picocom -qrX -b $baud --flow x --send-cmd ascii-xfr /dev/ttyUSB0
  else
    red "/dev/ttyUSB0 is not connected"
  fi

  # send xload 1 command
  if [ -e /dev/ttyUSB0 ]; then
    echo "xload 1" | picocom -qrix 1000 /dev/ttyUSB0
  fi

  # send hex file
  start=$(date +%s)
  if [ -e /dev/ttyUSB0 ]; then
    echo
    echo "[Sending file $folder/$hexver.hex]"
    echo
    echo "$stats" > ~/.xload  # send to file with extra newline
    cat /home/ec/hex-ftdi-cfg/$folder/$hexver.hex | picocom -qrix 1000 /dev/ttyUSB0 >> ~/.xload  # append file
    cat ~/.xload | GREP_COLORS='ms=01;32' grep --color=auto -E " S115| 12631| 201840| 198| 0x00080000| 0x000b146f| 0x00080000 to 0x000b146f| 0$|$"  # custom integers and zero
  fi
  end=$(date +%s)
  elapsed=$((end-start))

  # change baud rate, requires br3x suffix, need to rewrite using picocom
  echo
  echo "Setting baud rate to 115200"
  source ~/hex-ftdi-cfg/hex/baud-1.sh
  # python3 ~/HJS/statlog/statlog.py S2XX-baud.1-$undo | \grep "baud "  # >> /dev/null
  echo "Transfer time = $elapsed s"

  # requires poweroff
  if [ -e /dev/ttyUSB0 ]; then
    echo Run prodtest to verify the hardware. Cycle power to boot the new image.
  fi
  echo

  # play sound
  aplay ~/prodtest/bin/440.wav --quiet
fi

# End
