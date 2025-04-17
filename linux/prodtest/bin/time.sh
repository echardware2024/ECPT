#!/bin/bash

start=$(cat ~/.timezero)
now=$(date +%s%4N)
elapsedms=$((now-start))  # calc elapsed
elapsed=$(echo "$elapsedms/10000.0" | bc -l)
printf "\e[1;32mDone (t = %.1f s)\e[0m\n\n" "$elapsed"

# EOF
