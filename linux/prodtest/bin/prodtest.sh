#!/bin/bash

# purple
function purple_info () {  # converts parameter name and result to 'purple: white' and add section header
  printf "\e[1;35m%s: \e[0m%s\n" "$1" "$2"
}

# redple
function redple_info () {  # converts parameter name and result to 'purple: RED' and add section header
  printf "\e[1;35m%s: \e[0m\e[1;31m%s\e[0m\n" "$1" "$2"
}

# greple
function greple_info () {  # converts parameter name and result to 'purple: GREEN' and add section header
  printf "\e[1;35m%s: \e[0m\e[1;32m%s\e[0m\n" "$1" "$2"
}

# setup
sudo echo # forces root login
cd ~/prodtest/bin/  # change to prodtest bin
time_t=$(date +%s)  # get timestamp
hexstamp=$(printf "%x" $time_t)  # get hexstamp
hostname=$(hostname)  # get hostname
echo "[ProdTest on $hostname at UTC=0x$hexstamp] -> ~/.prodtest-$hexstamp" > ~/.prodtest-$hexstamp  # write timestamp to new log

# get serial number from FTDI
ftdi=$(source ./ftdi.sh)
purple_info "FTDI" "$ftdi"
cat ~/prodtest/bin/bar-ftdi >> ~/.prodtest-$hexstamp  # decimal SN

# get image location from BMC
nbmc=$(source ./info.sh)
if [ "$nbmc" == "Primary" ]; then
  redple_info "nBMC" "$nbmc ... Update using xl2/power-cycle"
elif [ "$nbmc" == "Secondary" ]; then
  greple_info "nBMC" "$nbmc (OK)"
else
  purple_info "nBMC" "$nbmc"  # all other results/errors, leave text white
fi
cat ~/prodtest/bin/bar-info >> ~/.prodtest-$hexstamp  # Primary or Secondary

# cfg edit string
cfge=$(source ./cfge.sh)
purple_info "CFGe" "$cfge"
cat ~/prodtest/bin/bar-cfge >> ~/.prodtest-$hexstamp  # reconstituted cfg edit string

# 1FDC:xxxx
pcie=$(source ./pcie.sh)
purple_info "PCIe" "$pcie"
cat ~/prodtest/bin/bar-pcie >> ~/.prodtest-$hexstamp  # PCIe without leading spaces, requires sudo

# verify CB/PG
cben=$(source ./cben.sh)
purple_info "CBEN" "$cben"
cat ~/prodtest/bin/bar-cben >> ~/.prodtest-$hexstamp  # compute blocks

# xlog
xlog=$(source ./xlog.sh)
purple_info "XLOG" "$xlog"
cat ~/prodtest/bin/bar-xlog >> ~/.prodtest-$hexstamp  # xlog noteworthy lines

# get serial number and card name
id_ftdi=$(cat ~/prodtest/bin/bar-ftdi | \grep -o -P "iProduct 2 FT230X on \K.*")  # unused
id_bmc=$(cat ~/prodtest/bin/bar-info | \grep -o -P "Board: EdgeCortix \K....")  # unused
sn_bmc=$(cat ~/prodtest/bin/bar-info | \grep -o -E ".....(-PAC|-EC-)..." | sed "s/-PAC//g" | sed "s/-EC-//g")  # SN for comparison with FTDI, allows -PAC and -EC- formats
variant=$(cat ~/prodtest/bin/bar-info | \grep -o -P "Board:.*variant \K...")  # should be D16 or S16, determines dma version

# setup and dma
bistfail=$(cat ~/.prodtest-$hexstamp | \grep -i "fail")  # check for failures
if [ -n "$bistfail" ]; then  # check if not empty
  printf "\e[1;31m%b\e[0m"  "ABORTED DUE TO BOOT/BIST/TEST FAILURE\n"
  dma="- - - -"
else
  cd ~/dna2_self_test_2_2_0/ > /dev/null  # setup must be run from the correct folder
  ./setup_3pg_none.sh > /dev/null 2>&1  # hide all of the spam, now skips dma_test
  cd - > /dev/null  # return to previous folder
  if [ "$variant" == "D16" ]; then
    dma=$(source ./dmad.sh)
  elif [ "$variant" == "S16" ]; then
    dma=$(source ./dmas.sh)
  else
    dma="(Unknown card type)"
  fi
  cat ~/prodtest/bin/bar-dma >> ~/.prodtest-$hexstamp
fi
purple_info "DMAx" "$dma"

# ./bmc test, requires driver to be installed, could check if card is available before running
chmod +x ~/prodtest/bin/bmc
~/prodtest/bin/bmc GetBmcInfor > ~/prodtest/bin/foo-qbmc 2>&1  # include stderr
qbmc_result=$(cat ~/prodtest/bin/foo-qbmc | \grep -i "bmcrevision" || echo "Failed to read BMC Revision")  # either read string or report error
printf "./bmc [bin] -> $qbmc_result\n" >> ~/.prodtest-$hexstamp

# debug /00 issue
# echo "HJS WAS HERE [NULL CHAR ISSUE]" >> ~/.prodtest-$hexstamp
# seems to be fixed with python script /00 replacement

# stats
stats=$(source ./stats.sh)
purple_info "TPIV" "$stats"
cat ~/prodtest/bin/bar-stats >> ~/.prodtest-$hexstamp

echo  # results with inverted grep
cat ~/.prodtest-$hexstamp | grep -v -i -E "(idvendor|idproduct|imanufacturer)"

# rename based on serial number
cfg4pt_fail=$(cat ~/.prodtest-$hexstamp | \grep "MISSING")  # should be empty, matches indicate serial failure
enpg_fail=$(cat ~/.prodtest-$hexstamp | \grep -E 'AEN|BEN|M2EN')  # should not be empty
if [ -n "$cfg4pt_fail" ]; then  # check if not empty
  printf "\n\e[1;31mSerial Failure during cfge\e[0m\n"
elif [ -z "$enpg_fail" ]; then  # check if empty
  printf "\n\e[1;31mSerial Failure during enpg\e[0m\n"
elif [ "${#ftdi}" -eq 8 ] && [ "$ftdi" == "$sn_bmc" ]; then
  printf "\e[1;32mVerify %s == %s \u2611\e[0m\n" $ftdi $sn_bmc
  # printf "Lot Code: ${sn_bmc:0:5}\n"
  mkdir -p ~/prodtest/"${sn_bmc:0:5}"
  printf "HJS "  # signature prefix
  mv -v ~/.prodtest-$hexstamp ~/prodtest/"${sn_bmc:0:5}"/"$sn_bmc"-0x"$hexstamp".txt  # rename file
  sn_command=$(printf "sn %s %s" "${sn_bmc:0:5}" "${sn_bmc:5:8}")  # store serial number command
  printf "\nDisplay all stats using command: %s (SHIFT-CTRL-V ENTER) or the alias \"last\"\n" "$sn_command"
  if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then  #SSH
    echo "  [SSH detected - \"$sn_command\" not copied to clipboard]"
  else
    echo $sn_command | xsel -b  # copy to clipboard
  fi
  echo $sn_command > ~/.last_sn  # write to hidden file
  printf "# $hexstamp\n" >> ~/.last_sn  # add timestamp to hidden file
  echo  # blank line before verification text
  ptv  # verify
else
  printf "\n\e[1;31mLength of serial number is incorrect or there is a mismatch: FTDI=$ftdi BMC=$sn_bmc\e[0m\n"
fi

echo
# EOF
