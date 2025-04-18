
# Added by EdgeCortix for ECPT (v4.15)

# System management
alias bios="systemctl reboot --firmware-setup"
alias 00="poweroff"
alias 01="reboot"
alias snap="killall snap-store && snap refresh"

# procedure steps
alias pt="source ~/prodtest/bin/prodtest.sh"
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
