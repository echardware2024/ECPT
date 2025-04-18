
# Print "ubuntu" to terminal screen on startup, with rev
echo "        _                 _         "
echo "  _   _| |__  _   _ _ __ | |_ _   _ "
echo " | | | | '_ \| | | | '_ \| __| | | |"
echo " | |_| | |_) | |_| | | | | |_| |_| | by HJS"
echo "  \__,_|_.__/ \__,_|_| |_|\__|\__,_| 0x0004"
echo

if [ -e ~/.auto_prodtest ]; then  # check if regular file exists
  uptime=$(uptime --since)
  cat ~/.auto_prodtest | grep "$uptime" > /dev/null  # check grep, discard result
  if [ $? -eq 0 ]; then  # grep match
    echo "[Skipping auto-prodtest]"
    echo  # newline before prompt
  else
    echo "$uptime" > ~/.auto_prodtest  # write boot time to auto file
    echo "[Starting auto-prodtest, disable with pt-]"
    echo  # newline before sudo entry
    prodtest
  fi
fi

# aliases for ECPT (v4.15)

# System management
alias bios="systemctl reboot --firmware-setup"
alias 00="poweroff"
alias 01="reboot"
alias snap="killall snap-store && snap refresh"

# procedure steps
alias pt="source ~/prodtest/bin/prodtest.sh"
alias pt+="echo 'enabling auto-prodtest' ; echo 'The world is a vampire' > ~/.auto_prodtest"
alias pt-="printf 'disabling auto-prodtest: ' ; rm -v ~/.auto_prodtest 2>&1 | \grep removed || echo 'already disabled'"
alias x2="source ~/hex-ftdi-cfg/hex/xl2.sh ; echo '[Running prodtest after xload]' ; pt ; printf 'Cycle Power NOW (00)...\n\n'"
alias b8="printf '\n\e[1;35mRun xxf to summarize failures...\e[0m\n' && bist 8"
alias d3="t0 ; dryi ; tt ; echo "..." ; dry3 ; tt"
alias d3b="t0 ; drybi ; tt ; echo "..." ; dry3b ; tt"
alias t6="trump 6"

# tests
alias bist="source ~/prodtest/bin/bist.sh"
alias dryi="sudo echo 'dry init with dma_test:' && cd ~/dna2_self_test_2_2_0/ && ./setup_3pg_zero.sh ; echo ; printf '\e[1;35m   Ensure that compute blocks 01 and 02 are enabled.\e[0m\n\n'"
alias drybi="sudo echo 'dry init with dma_test:' && cd ~/dna2_self_test_2_2_0/ && ./setup_3pg_one.sh ; echo ; printf '\e[1;35m   Ensure that compute blocks 01 and 02 are enabled.\e[0m\n\n'"
alias dry3="cd ~/dna2_self_test_2_2_0/ && ./run_3pg.sh 999"
alias dry3b="cd ~/dna2_self_test_2_2_0/ && ./run_3pg.sh 999 1"
alias trump="source ~/prodtest/bin/trump.sh"

# End of EdgeCortix
