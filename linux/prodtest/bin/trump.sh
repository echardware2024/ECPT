#!/bin/bash

s2i  # initialize MERA
cd ~/mera_package/examples/chatbot/
printf "\e[1;35minit complete\e[0m -HJS\n"

if [ $# -gt 0 ]; then  # one or more args passed
  count=$1  # set count equal to first arg
else
  count=1  # default to 1
fi

if [ $# == 2 ]; then 
  query="--input_txt \"$2\""  # set query to second arg
else
  query="--input_txt \"Tell me about Trump.\""  # default
fi

# get start time
start=$(date +%s%4N)

# iterate
for (( i=0; i<$count; i++ )); do
  now=$(date +%s%4N)
  elapsedms=$((now-start))  # calc elapsed
  elapsed=$(echo "$elapsedms/10000.0" | bc -l)
  printf "\n\e[1;32mi = $i\nt = %.1f s\e[0m\n\n" "$elapsed"
  echo "$query" | xargs python3 demo_model.py
done

de
cd
echo
s2
now=$(date +%s%4N)
elapsedms=$((now-start))  # calc elapsed
elapsed=$(echo "$elapsedms/10000.0" | bc -l)
if [ $count == 1 ]; then
  printf "\n\e[1;32mCompleted 1 query.\nt = %.1f s\e[0m\n\n" "$elapsed"
else
  printf "\n\e[1;32mCompleted $i queries.\nt = %.1f s\e[0m\n\n" "$elapsed"
fi

# EOF
