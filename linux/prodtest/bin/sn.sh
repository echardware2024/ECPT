#!/bin/bash
echo

if [ $# == 2 ]; then
  foo=$(printf "$HOME/prodtest/%s/" "$1" )
  bar=$(printf "%s%s" "$1" "$2")
  star=-*
  # echo "DEBUG: $foo $bar"
  valid=$(find "$foo" -name "$bar$star")
  if [ -z "$valid" ]; then
    printf "   \e[1;31mSerial number not found: %s%s\e[0m\n" "$1" "$2"
  else
    printf "Summary for serial number %s%s" "$1" "$2" # start of summary line
    foobar=$(printf "%s%s" "$foo" "$bar")
    # printf " in \e[1;35m$foobar%s\e[0m\n" "$star" # finish the previous line
    printf "\n" # finish the previous line, short version

    printf "Log count: "
    cat $foobar$star | grep -o -i 'board.*edgecortix' | wc -l

    printf "BIST pass: "
    cat $foobar$star | grep -o -i 'bist.*pass' | wc -l
    printf "BIST fail: "
    total=$(cat $foobar$star | grep -o -i 'bist.*fail' | wc -l)
    a0=$(cat $foobar$star | grep -o -i 'bist.*sakura a.*ddr0.*fail' | wc -l)
    a1=$(cat $foobar$star | grep -o -i 'bist.*sakura a.*ddr1.*fail' | wc -l)
    b0=$(cat $foobar$star | grep -o -i 'bist.*sakura b.*ddr0.*fail' | wc -l)
    b1=$(cat $foobar$star | grep -o -i 'bist.*sakura b.*ddr1.*fail' | wc -l)
    if [ "$total" != "0" ]; then
      printf "$total [$a0 $a1 $b0 $b1]\n"
    else
      printf "\n"
    fi

    printf "DMA pass: "
    cat $foobar$star | grep -o -i 'trial.*pass' | wc -l
    printf "DMA fail: "
    total=$(cat $foobar$star | grep -o -i 'trial.*fail' | wc -l)
    a0=$(cat $foobar$star | grep -o -i 'failed.*device ID = 0.*ddr0' | wc -l)
    a1=$(cat $foobar$star | grep -o -i 'failed.*device ID = 0.*ddr1' | wc -l)
    b0=$(cat $foobar$star | grep -o -i 'failed.*device ID = 1.*ddr0' | wc -l)
    b1=$(cat $foobar$star | grep -o -i 'failed.*device ID = 1.*ddr1' | wc -l)
    if [ "$total" != "0" ]; then
      printf "$total [$a0 $a1 $b0 $b1]\n"
    else
      printf "\n"
    fi

    my_array=("Wr (GB/s):")
    wr=$(cat $foobar$star | grep -i -o -P 'write speed =\K [0-9]\.[0-9]' | sed "s/[[:space:]]//g")
    while read line; do
      if [[ ! " ${my_array[@]} " =~ " ${line} " ]]; then
        my_array+=("${line}")
      fi
    done <<< "$wr"
    echo "${my_array[@]}"

    my_array=("Rd (GB/s):")
    rd=$(cat $foobar$star | grep -i -o -P 'read speed =\K [0-9]\.[0-9]' | sed "s/[[:space:]]//g")
    while read line; do
      if [[ ! " ${my_array[@]} " =~ " ${line} " ]]; then
        my_array+=("${line}")
      fi
    done <<< "$rd"
    echo "${my_array[@]}"

    my_array=("T-SAK:")
    if [ "$1" == "52979" ] || [ "$1" == "52980" ] || [ "$1" == "53287" ] ; then  # LP card, need to fix eventually
      t="n/a"
    else
      t=$(cat $foobar$star | grep -o -P 'MAX,.*,.*,.*,\s+\K.+,' | sed "s/\.00,//g")
    fi
    while read line; do
      if [[ ! " ${my_array[@]} " =~ " ${line} " ]]; then
        my_array+=("${line}")
      fi
    done <<< "$t"
    echo "${my_array[@]}"
  fi
else  # wrong number of args
  printf "Usage:\n   Enter the lot code and serial number as parameters.\nExample:\n   sn 12345 001\n"
fi

echo
# EOF
