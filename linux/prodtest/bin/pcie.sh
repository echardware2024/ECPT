#!/bin/bash

foo="./foo-pcie"
bar="./bar-pcie"

# make sure files are empty, start with timestamp
printf "%s\n" "$(date)" > $foo
printf "%s\n" "$(date)" > $bar

sudo lspci -vvv -d 1fdc: > $foo
cat $foo | \grep -E '1fdc|Subsystem:|LnkSta:|Region 0:|Region 2:|Region 4:' | awk '{$1=$1;print}' | sed '0,/LnkSta/{s/LnkSta/A.LnkSta/}' | sed 's/^LnkSta/B.LnkSta/' > $bar
pcie=$(cat $bar | \grep -i -o -P 'Speed.*' || echo "(Unknown PCIe Status)")  # get speed and width
echo $pcie | sed "s/) /) - /g" | sed "s/),/)/g"  # print after replacing some chars

# EOF

# cd ~/prodtest/bin/ && source pcie.sh
