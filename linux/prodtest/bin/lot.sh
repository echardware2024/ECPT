#!/bin/bash
echo

declare -a foo=()  # empty array
if [ $# == 2 ]; then  # expects two args

  lotcode=$1
  count=$2

  if [ $count -lt 1 ]; then
    foo+=("000")  # always do 000
    foo+=("001")  # always do 001
  else
    for (( i=-1; i<$count; i++ )); do  # first will be zero, last will be count-1+1
      bar=$((i+1))
      formatted=$(printf "%03d\n" $bar)
      foo+=($formatted)
    done
  fi

  for i in "${foo[@]}"; do
    echo "HJS WAS HERE" > "$HOME/prodtest/$lotcode/$lotcode$i-xxx.tmp"  # these files could be deleted at the end
    zeroruns=$(sn "$lotcode" "$i" | grep -a "Log count: 0")  # look for log count of zero
    if [ -z "$zeroruns" ]; then  # if result is empty, log count is non-zero
      sn "$lotcode" "$i" | awk NF  # run the serial number script then format+print
      echo
    fi
  done

else  # wrong number of args
  printf "Usage:\n   Enter the lot code and max serial number as parameters.\nExample:\n   lot 12345 5\n"
  echo
fi

# EOF
